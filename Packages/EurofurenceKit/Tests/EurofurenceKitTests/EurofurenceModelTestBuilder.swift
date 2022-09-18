import CoreData
@testable import EurofurenceKit
import EurofurenceWebAPI
import XCTest

class FakeClock: Clock {
    
    let significantTimeChangePublisher = SignificantTimeChangePublisher(.distantPast)
    
    func simulateTimeChange(to time: Date) {
        significantTimeChangePublisher.send(time)
    }
    
}

@MainActor
class EurofurenceModelTestBuilder {
    
    @MainActor
    struct Scenario {
        var model: EurofurenceModel
        var modelProperties: FakeModelProperties
        var api: FakeEurofurenceAPI
        var clock: FakeClock
    }
    
    private var conventionIdentifier: ConventionIdentifier = .current
    private var keychain: Keychain = UnauthenticatedKeychain()
    private var api = FakeEurofurenceAPI()
    
    func with(conventionIdentifier: ConventionIdentifier) -> Self {
        self.conventionIdentifier = conventionIdentifier
        return self
    }
    
    func with(keychain: Keychain) -> Self {
        self.keychain = keychain
        return self
    }
    
    func with(api: FakeEurofurenceAPI) -> Self {
        self.api = api
        return self
    }
    
    @discardableResult
    func build() async -> Scenario {
        let properties = FakeModelProperties()
        let clock = FakeClock()
        let configuration = EurofurenceModel.Configuration(
            environment: .memory,
            properties: properties,
            keychain: keychain,
            api: api,
            conventionIdentifier: conventionIdentifier,
            clock: clock
        )
        
        let model = EurofurenceModel(configuration: configuration)
        await model.prepareForPresentation()
        
        return Scenario(model: model, modelProperties: properties, api: api, clock: clock)
    }
    
}

extension EurofurenceModelTestBuilder.Scenario {
    
    var viewContext: NSManagedObjectContext {
        model.viewContext
    }
    
    func stubSyncResponse(
        with result: Result<SynchronizationPayload, Error>,
        for generationToken: SynchronizationPayload.GenerationToken? = nil
    ) async {
        await api.stubNextSyncResponse(result, for: generationToken)
        
        // Pre-emptively mark all image requests as successful. Failing requests will need to be designated by the
        // corresponding tests.
        
        if case .success(let payload) = result {
            for image in payload.images.changed {
                await api.stub(
                    .success(()),
                    forImageIdentifier: image.id,
                    lastKnownImageContentHashSHA1: image.contentHashSha1,
                    downloadDestinationURL: modelProperties.proposedURL(forImageIdentifier: image.id)
                )
            }
        }
    }
    
    func updateLocalStore(using response: SampleResponse) async throws {
        let synchronizationPayload = try response.loadResponse()
        await stubSyncResponse(with: .success(synchronizationPayload))
        try await model.updateLocalStore()
    }
    
    func updateLocalStore() async throws {
        try await model.updateLocalStore()
    }
    
    func simulateTimeChange(to time: Date) {
        clock.simulateTimeChange(to: time)
    }
    
}
