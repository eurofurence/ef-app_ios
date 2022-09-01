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
    
    func with(conventionIdentifier: ConventionIdentifier) -> Self {
        self.conventionIdentifier = conventionIdentifier
        return self
    }
    
    func build() -> Scenario {
        let properties = FakeModelProperties()
        let api = FakeEurofurenceAPI()
        let configuration = EurofurenceModel.Configuration(
            environment: .memory,
            properties: properties,
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
    
    func stubSyncResponse(with result: Result<SynchronizationPayload, Error>) {
        api.nextSyncResponse = result
    }
    
    func stubSyncResponse(contentsOf jsonFile: String) throws {
        let bundle = Bundle.module
        let url = try XCTUnwrap(bundle.url(forResource: jsonFile, withExtension: "json"))
        let data = try Data(contentsOf: url)
        let decoder = EurofurenceAPIDecoder()
        let payload = try decoder.decodeSynchronizationPayload(from: data)
        stubSyncResponse(with: .success(payload))
    }
    
    func stubSyncResponse(responseData: Data) throws {
        let decoder = EurofurenceAPIDecoder()
        let payload = try decoder.decodeSynchronizationPayload(from: responseData)
        stubSyncResponse(with: .success(payload))
    }
    
    func updateLocalStore<Response>(using response: Response) async throws where Response: SampleResponseFile {
        try stubSyncResponse(responseData: try response.loadFileContents())
        try await model.updateLocalStore()
    }
    
    func updateLocalStore() async throws {
        try await model.updateLocalStore()
    }
    
}
