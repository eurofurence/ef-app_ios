import CoreData
@testable import EurofurenceKit
import XCTest

class IngestingFullRemoteModel_EventDedupeTests: EurofurenceKitTestCase {
    
    func testIngestingFullResponse_DoesNotDuplicateHosts() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        
        // For each panel host, there should be one instance with the corresponding name associated with one or more
        // events. Witnessing the same host multiple times implies it has been instantiated on a per-Event basis.
        let fetchRequest: NSFetchRequest<PanelHost> = PanelHost.fetchRequest()
        let panelHosts = try scenario.viewContext.fetch(fetchRequest)
        
        var witnessedPanelHostsByName = [String: PanelHost]()
        for panelHost in panelHosts {
            if witnessedPanelHostsByName[panelHost.name] != nil {
                XCTFail("Multiple copies of \(panelHost.name) in the persistent store")
                return
            }
            
            witnessedPanelHostsByName[panelHost.name] = panelHost
            
            XCTAssertGreaterThanOrEqual(panelHost.hostingEvents.count, 1)
        }
    }
    
    func testIngestingFullResponse_DoesNotDuplicateTags() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        
        // For each panel tag, there should be one instance with the corresponding name associated with one or more
        // events. Witnessing the same tag multiple times implies it has been instantiated on a per-Event basis.
        let fetchRequest: NSFetchRequest<Tag> = Tag.fetchRequest()
        let tags = try scenario.viewContext.fetch(fetchRequest)
        
        var witnessedTagsByName = [String: Tag]()
        for tag in tags {
            if witnessedTagsByName[tag.name] != nil {
                XCTFail("Multiple copies of \(tag.name) in the persistent store")
                return
            }
            
            witnessedTagsByName[tag.name] = tag
            
            XCTAssertGreaterThanOrEqual(tag.events.count, 1)
        }
    }

}
