import CoreData
import EurofurenceWebAPI
import Foundation
import SwiftUI

extension EurofurenceModel {
    
    /// Content classifications for previewing.
    public enum PreviewContent {
        
        /// Use content from EF26 for previewing.
        case ef26
        
        /// Retains payloads cached in the previewing process to speed up render time.
        private static var payloadCache = [PreviewContent: SynchronizationPayload]()
        
        fileprivate var conventionIdentifier: ConventionIdentifier {
            switch self {
            case .ef26:
                return ConventionIdentifier("EF26")
            }
        }
        
        fileprivate var synchronizationPayload: SynchronizationPayload {
            if let cachedPayload = Self.payloadCache[self] {
                return cachedPayload
            }
            
            switch self {
            case .ef26:
                let bundle = Bundle.previewing
                guard let url = bundle.url(forResource: "EF26PreviewResponse", withExtension: "json") else {
                    fatalError("Cannot find previewing content URL in Package bundle")
                }
                
                guard let data = try? Data(contentsOf: url) else {
                    fatalError("Failed to load previewing data from URL")
                }
                
                do {
                    let decoder = EurofurenceAPIDecoder()
                    let response = try decoder.decodeSynchronizationPayload(from: data)
                    Self.payloadCache[.ef26] = response
                    
                    return response
                } catch {                    
                    fatalError("Failed to decode synchronization payload from previewing data. Error=\(error)")
                }
            }
        }
        
    }
    
    /// Authentication states for previewing.
    public enum AuthenticationState {
        
        /// Preview with an authenticated user.
        case authenticated
        
        /// Preview with an unauthenticated user.
        case unauthenticated
        
    }
    
    /// Synchronisation states for previewing.
    public enum CloudState {
        
        /// No update has occurred.
        case idle
        
        /// An update is ongoing, with either known or indeterminate progress.
        case updating(fractionComplete: Float?)
        
        /// The update failed.
        case failed
        
        /// The update succeeded.
        case updated
        
        @MainActor
        fileprivate func configure(model: EurofurenceModel) {
            switch self {
            case .idle:
                model.cloudStatus = .idle
                
            case .updating(let fractionComplete):
                let progress = EurofurenceModel.Progress()
                if let fractionComplete = fractionComplete {
                    progress.update(totalUnitCount: 100)
                    
                    let percentComplete = Int(fractionComplete) * 100
                    for _ in 0..<percentComplete {
                        progress.updateCompletedUnitCount()
                    }
                }
                
                model.cloudStatus = .updating(progress: progress)
                
            case .failed:
                model.cloudStatus = .failed
                
            case .updated:
                model.cloudStatus = .updated
            }
        }
        
    }
    
    /// Produces a model suitable for previewing within a SwiftUI canvas.
    ///
    /// Due to the way in which SwiftUI property wrappers are evaluated, the preview model must be instantiated first
    /// before installation within a view tree - e.g.:
    ///
    /// ```
    /// let preview: EurofurenceModel = .preview()
    /// ContentView()
    ///    .environmentModel(preview)
    /// ```
    ///
    /// For simplicities sake, you can also pass a `ViewBuilder` as the trailing argument to manage the order of
    /// execution problem. The previewing model will be automatically installed into the view tree:
    ///
    /// ```
    /// EurofurenceModel.preview {
    ///     ContentView()
    /// }
    /// ```
    ///
    /// Previews using the Eurofurence model must be previewed while the preview is running in the canvas. The model
    /// does not support synchronous snapshot-based previewing due to the asynchronous manner in which data is fed
    /// in.
    ///
    /// - Parameters:
    ///   - content: The preview content classification to apply to the in-memory model.
    ///   - authenticationState: The authentication state for previewing.
    ///   - cloudStatus: The cloud status state for previewing.
    /// - Returns: An in-memory `EurofurenceModel` pre-populated with the supplied state.
    public static func preview(
        content: PreviewContent = .ef26,
        authenticationState: AuthenticationState = .unauthenticated,
        cloudStatus: EurofurenceModel.CloudState = .updated
    ) -> EurofurenceModel {
        let keychain = PreviewingKeychain(state: authenticationState)
        let api = PreviewingEurofurenceAPI(synchronizationPayload: content.synchronizationPayload)
        let properties = PreviewingModelProperties()
        
        let configuration = EurofurenceModel.Configuration(
            environment: .memory,
            properties: properties,
            keychain: keychain,
            api: api,
            conventionIdentifier: content.conventionIdentifier
        )
        
        let model = EurofurenceModel(configuration: configuration)
        cloudStatus.configure(model: model)
        
        let operation = UpdateLocalStoreOperation(progress: EurofurenceModel.Progress())
        let writingContext = configuration.persistentContainer.newBackgroundContext()
        let operationContext = UpdateOperationContext(
            managedObjectContext: writingContext,
            keychain: keychain,
            api: api,
            properties: properties,
            conventionIdentifier: content.conventionIdentifier
        )
        
        do {
            try operation.ingestSyncResponse(content.synchronizationPayload, context: operationContext)
            
            // Manually inject all the images for each entity.
            try writingContext.performAndWait { [writingContext] in
                let imagesFetchRequest: NSFetchRequest<EurofurenceKit.Image> = EurofurenceKit.Image.fetchRequest()
                let images = try writingContext.fetch(imagesFetchRequest)
                
                for image in images {
                    let urlForImage = properties.proposedURL(forImageIdentifier: image.identifier)
                    image.cachedImageURL = urlForImage
                }
                
                try writingContext.save()
            }
        } catch {
            fatalError("Failed to prepare model for previewing. Error=\(error)")
        }
        
        return model
    }
    
    /// Evaluates a preview `ViewBuilder` by supplying a preview model object.
    ///
    /// Previews using the Eurofurence model must be previewed while the preview is running in the canvas. The model
    /// does not support synchronous snapshot-based previewing due to the asynchronous manner in which data is fed
    /// in.
    /// 
    /// - Parameters:
    ///   - content: The preview content classification to apply to the in-memory model.
    ///   - authenticationState: The authentication state for previewing.
    ///   - cloudStatus: The cloud status state for previewing.
    ///   - previewBody: A closure to produce the previewing `View` for the canvas. The previewing model is supplied as
    ///                  a parameter, and is also pre-emptively injected into the preview's environment.
    /// - Returns: The preview for the SwiftUI canvas suitable for previewing against the model.
    public static func preview<Body>(
        content: PreviewContent = .ef26,
        authenticationState: AuthenticationState = .unauthenticated,
        cloudStatus: EurofurenceModel.CloudState = .updated,
        @ViewBuilder previewBody: @escaping (EurofurenceModel) -> Body
    ) -> some View where Body: View {
        let model = self.preview(content: content, authenticationState: authenticationState, cloudStatus: cloudStatus)
        return PreviewContainer(previewBody: previewBody, model: model)
    }
    
    private struct PreviewContainer<PreviewBody>: View where PreviewBody: View {
        
        var previewBody: (EurofurenceModel) -> PreviewBody
        var model: EurofurenceModel
        
        var body: some View {
            previewBody(model)
                .environmentModel(model)
        }
        
    }
    
    // MARK: - Well-Defined Entities
    
    public enum PreviewDay {
        case earlyArrival
        case conDayOne
        case conDayTwo
        
        fileprivate var identifier: String {
            switch self {
            case .earlyArrival:
                return "db6e0b07-3300-4d58-adfd-84c145e36242"
                
            case .conDayOne:
                return "572ca56c-c473-4ca7-b4ec-c6498c077dda"
                
            case .conDayTwo:
                return "7f69f120-3c8a-49bf-895a-20c2adade161"
            }
        }
    }
    
    public func day(for day: PreviewDay) -> Day {
        let id = day.identifier
        
        do {
            return try self.day(identifiedBy: id)
        } catch {
            fatalError("Failed to find day from preview JSON with ID \(id)")
        }
    }
    
    public enum PreviewTrack {
        case artShow
        case clubStage
        
        fileprivate var identifier: String {
            switch self {
            case .artShow:
                return "f23cc7f6-34c1-48d5-8acb-0ec10c353403"
                
            case .clubStage:
                return "1af389c5-7e1c-4524-8db2-ce7551b3c4eb"
            }
        }
    }
    
    public func track(for track: PreviewTrack) -> Track {
        let id = track.identifier
        
        do {
            return try self.track(identifiedBy: id)
        } catch {
            fatalError("Failed to find track from preview JSON with ID \(id)")
        }
    }
    
    public enum PreviewEvent {
        case registration
        case bootyBounce
        case deadDog
        
        fileprivate var identifier: String {
            switch self {
            case .registration:
                return "76430fe0-ece7-48c9-b8e6-fdbc3974ff64"
                
            case .bootyBounce:
                return "0d7817c3-03c4-48a7-bcf9-5cd690e86368"
                
            case .deadDog:
                return "d3e5252b-8521-42ab-bd1a-d67f58c0f10f"
            }
        }
    }
    
    public func event(for event: PreviewEvent) -> Event {
        let id = event.identifier
        
        do {
            return try self.event(identifiedBy: id)
        } catch {
            fatalError("Failed to find event from preview JSON with ID \(id)")
        }
    }
    
}
