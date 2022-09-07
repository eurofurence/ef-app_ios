import EurofurenceWebAPI
import Foundation
import SwiftUI

extension Bundle {
    
    private class BundleScope { }
    
    static var moduleWorkaround: Bundle {
        let cocoaTouchBundleName = "LocalPackages_EurofurenceKit"
        let cocoaBundleName = "EurofurenceKit_EurofurenceKit"
        
        let appLinkedBundleURL = Bundle.main.resourceURL
        let commandLineBundleURL = Bundle.main.bundleURL
        let frameworkLinkedBundleURL = Bundle(for: BundleScope.self).resourceURL
        let uiTestingBundleURL = frameworkLinkedBundleURL?.deletingLastPathComponent()
        let crossPackagePreviewBundleURL = frameworkLinkedBundleURL?
            .deletingLastPathComponent()
            .deletingLastPathComponent()
        
        let candidates = [
            appLinkedBundleURL,
            commandLineBundleURL,
            frameworkLinkedBundleURL,
            uiTestingBundleURL,
            crossPackagePreviewBundleURL
        ]
        .compactMap { $0 }
        
        let bundlePaths = candidates.flatMap { (candidate) in
            return [
                candidate.appendingPathComponent("\(cocoaTouchBundleName).bundle"),
                candidate.appendingPathComponent("\(cocoaBundleName).bundle")
            ]
        }
        
        let bundle = bundlePaths
            .lazy
            .compactMap(Bundle.init(url:))
            .first
        
        if let bundle = bundle {
            return bundle
        }
        
        fatalError("No EurofurenceKit bundle found")
    }
    
}

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
                let bundle = Bundle.moduleWorkaround
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
    /// - Parameters:
    ///   - content: The preview content classification to apply to the in-memory model.
    ///   - authenticationState: The authentication state for previewing.
    /// - Returns: An in-memory `EurofurenceModel` pre-populated with the supplied state.
    public static func preview(
        content: PreviewContent = .ef26,
        authenticationState: AuthenticationState = .unauthenticated
    ) -> EurofurenceModel {
        let configuration = EurofurenceModel.Configuration(
            environment: .memory,
            properties: PreviewingModelProperties(),
            keychain: PreviewingKeychain(state: authenticationState),
            api: PreviewingEurofurenceAPI(synchronizationPayload: content.synchronizationPayload),
            conventionIdentifier: content.conventionIdentifier
        )
        
        let model = EurofurenceModel(configuration: configuration)

        // We'll return the model right away while it loads in the contents of the store.
        let semaphore = DispatchSemaphore(value: 0)
        Task {
            do {
                await model.prepareForPresentation()
                try await model.updateLocalStore()
            } catch {
                print("Failed to prepare model for previewing. Error=\(error)")
            }
            
            semaphore.signal()
        }
        
        semaphore.wait()
        
        return model
    }
    
    /// Evaluates a preview `ViewBuilder` by supplying a preview model object.
    /// 
    /// - Parameters:
    ///   - content: The preview content classification to apply to the in-memory model.
    ///   - authenticationState: The authentication state for previewing.
    ///   - previewBody: A closure to produce the previewing `View` for the canvas. The previewing model is supplied as
    ///                  a parameter, and is also pre-emptively injected into the preview's environment.
    /// - Returns: The preview for the SwiftUI canvas suitable for previewing against the model.
    public static func preview<Body>(
        content: PreviewContent = .ef26,
        authenticationState: AuthenticationState = .unauthenticated,
        @ViewBuilder previewBody: (EurofurenceModel) -> Body
    ) -> some View where Body: View {
        let previewModel = self.preview(content: content, authenticationState: authenticationState)
        return previewBody(previewModel)
            .environmentModel(previewModel)
    }
    
    // MARK: - Previewing Configuration
    
    private class PreviewingModelProperties: EurofurenceModelProperties {
        
        var containerDirectoryURL: URL {
            FileManager.default.temporaryDirectory.appendingPathComponent("EurofurenceKitPreview")
        }
        
        var synchronizationChangeToken: SynchronizationPayload.GenerationToken?
        
        func removeContainerResource(at url: URL) throws {
            
        }
        
    }
    
    private class PreviewingKeychain: Keychain {
        
        init(state: AuthenticationState) {
            switch state {
            case .authenticated:
                credential = Credential(
                    username: "Preview User",
                    registrationNumber: 42,
                    authenticationToken: AuthenticationToken("Unused"),
                    tokenExpiryDate: .distantFuture
                )
                
            case .unauthenticated:
                credential = nil
            }
        }
        
        var credential: Credential?
        
    }
    
    private struct PreviewingEurofurenceAPI: EurofurenceAPI {
        
        var synchronizationPayload: SynchronizationPayload
        
        func fetchChanges(
            since previousChangeToken: SynchronizationPayload.GenerationToken?
        ) async throws -> SynchronizationPayload {
            synchronizationPayload
        }
        
        func downloadImage(
            _ request: DownloadImage
        ) async throws {
            
        }
        
        func requestAuthenticationToken(
            using login: LoginRequest
        ) async throws -> AuthenticatedUser {
            AuthenticatedUser(
                userIdentifier: 42,
                username: "Previewing User",
                token: "Unused",
                tokenExpires: .distantFuture
            )
        }
        
        func registerPushNotificationToken(
            registration: RegisterPushNotificationDeviceToken
        ) async throws {
            
        }
        
        func requestLogout(
            _ logout: LogoutRequest
        ) async throws {
            
        }
        
        func fetchRemoteConfiguration() async -> RemoteConfiguration {
            PreviewingRemoteConfiguration()
        }
        
        func fetchMessages(for authenticationToken: AuthenticationToken) async throws -> [EurofurenceWebAPI.Message] {
            []
        }
        
        func markMessageAsRead(
            request: AcknowledgeMessageRequest
        ) async throws {
            
        }
        
    }
    
    private struct PreviewingRemoteConfiguration: RemoteConfiguration {
        
        let onChange = RemoteConfigurationChangedPublisher()
        
        subscript<Key>(key: Key.Type) -> Key.Value? where Key: RemoteConfigurationKey {
            nil
        }
        
    }
    
}
