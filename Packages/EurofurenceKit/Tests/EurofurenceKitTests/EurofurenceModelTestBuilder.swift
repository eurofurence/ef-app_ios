import CoreData
@testable import EurofurenceKit
import EurofurenceWebAPI
import XCTest

class EurofurenceModelTestBuilder {
    
    struct Scenario {
        var model: EurofurenceModel
        var modelProperties: FakeModelProperties
        var api: FakeEurofurenceAPI
    }
    
    private var conventionIdentifier: ConventionIdentifier = .current
    private var keychain: Keychain = UnauthenticatedKeychain()
    
    func with(conventionIdentifier: ConventionIdentifier) -> Self {
        self.conventionIdentifier = conventionIdentifier
        return self
    }
    
    func with(keychain: Keychain) -> Self {
        self.keychain = keychain
        return self
    }
    
    func build() -> Scenario {
        let properties = FakeModelProperties()
        let api = FakeEurofurenceAPI()
        let configuration = EurofurenceModel.Configuration(
            environment: .memory,
            properties: properties,
            keychain: keychain,
            api: api,
            conventionIdentifier: conventionIdentifier
        )
        
        let model = EurofurenceModel(configuration: configuration)
        
        return Scenario(model: model, modelProperties: properties, api: api)
    }
    
}

extension EurofurenceModelTestBuilder.Scenario {
    
    var viewContext: NSManagedObjectContext {
        model.viewContext
    }
    
    func stubSyncResponse(with result: Result<SynchronizationPayload, Error>) async {
        await api.stubNextSyncResponse(result)
    }
    
    func updateLocalStore(using response: SampleResponse) async throws {
        let synchronizationPayload = try response.loadResponse()
        await stubSyncResponse(with: .success(synchronizationPayload))
        try await model.updateLocalStore()
    }
    
    func updateLocalStore() async throws {
        try await model.updateLocalStore()
    }
    
}
