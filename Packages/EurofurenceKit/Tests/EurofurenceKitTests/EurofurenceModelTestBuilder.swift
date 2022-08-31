import CoreData
@testable import EurofurenceKit
import Logging
import XCTest

class EurofurenceModelTestBuilder {
    
    struct Scenario {
        var model: EurofurenceModel
        var network: FakeNetwork
    }
    
    private var conventionIdentifier: ConventionIdentifier = .current
    
    func with(conventionIdentifier: ConventionIdentifier) -> Self {
        self.conventionIdentifier = conventionIdentifier
        return self
    }
    
    func build() -> Scenario {
        let logger = Logger(label: "Test")
        let network = FakeNetwork()
        let configuration = EurofurenceModel.Configuration(
            environment: .memory,
            network: network,
            logger: logger,
            conventionIdentifier: conventionIdentifier
        )
        
        let model = EurofurenceModel(configuration: configuration)
        
        return Scenario(model: model, network: network)
    }
    
}

extension EurofurenceModelTestBuilder.Scenario {
    
    var viewContext: NSManagedObjectContext {
        model.viewContext
    }
    
    func stubSyncResponse(with result: Result<Data, Error>) {
        let syncURL = URL(string: "https://app.eurofurence.org/EF26/api/Sync")!
        network.stub(url: syncURL, with: result)
    }
    
    func updateLocalStore<Response>(using response: Response) async throws where Response: SampleResponseFile {
        stubSyncResponse(with: .success(try response.loadFileContents()))
        try await model.updateLocalStore()
    }
    
    func updateLocalStore() async throws {
        try await model.updateLocalStore()
    }
    
}
