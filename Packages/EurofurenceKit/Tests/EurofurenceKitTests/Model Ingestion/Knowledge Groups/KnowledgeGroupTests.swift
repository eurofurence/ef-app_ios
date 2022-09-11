import CoreData
@testable import EurofurenceKit
import XCTest

class KnowledgeGroupTests: EurofurenceKitTestCase {
    
    func testFetchingOrderedGroupsProducesArrayWhereGroupsOrderedByOrderingToken() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        
        let fetchRequest = KnowledgeGroup.orderedGroupsFetchRequest()
        let fetchResults = try scenario.viewContext.fetch(fetchRequest)
        
        let expectedGroupIdentifiers: [String] = [
            "ec031cbf-d8d0-825d-4c36-b782ed8d19d8", // Order = 0
            "6232ae2f-4e9d-fcf4-6341-f1751b405e45", // Order = 1
            "3f733bc5-d41f-e233-3cae-1df9ee5c39b6", // Order = 2
            "66e14f56-743c-1ece-a50c-b691143a3f93", // Order = 3
            "d3c10dde-0c9b-1111-1a61-33b76a562a3c", // Order = 4
            "6f91eaf9-68dc-4744-9da8-1bfc7d0052af", // Order = 5
            "9bf9b01f-e655-bec2-35ae-d72ebe38c245", // Order = 6
            "72cdaaba-e980-fa1a-ce94-7a1cc19d0f79", // Order = 8
            "92cdf214-7e9f-6bfa-0370-dfadd5e76493"  // Order = 9
        ]
        
        let actualGroupIdentifiers = fetchResults.map(\.identifier)
        
        XCTAssertEqual(
            expectedGroupIdentifiers,
            actualGroupIdentifiers, "Expected knowledge groups to be ordered by their ordering property"
        )
    }
    
    func testEntriesInGroupRemainInExpectedOrderFromResponse() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        
        let generalInformationGroupIdentifier = "ec031cbf-d8d0-825d-4c36-b782ed8d19d8"
        let generalInformationGroup = try scenario.model.knowledgeGroup(identifiedBy: generalInformationGroupIdentifier)
        
        let expectedEntryIdentifiers: [String] = [
            "ad3a1b4f-4fe5-d0f4-3926-d81e0703260b", // Order = 0
            "e2e71ccf-5745-0d50-966f-c815d1f51090", // Order = 1
            "9e3ebe4b-21dd-ac7d-b50e-303865aec655", // Order = 2
            "5c153574-836d-8ccb-0ddd-5b16b57251c9", // Order = 3
            "01f4cc9a-f41d-2fd3-e4e3-41ecbee75efe", // Order = 4
            "6905fb65-b212-4180-b1c1-efb42480d858", // Order = 5
            "5f36ae23-87ff-6f71-93b4-c823da6fb27e", // Order = 8
            "ec98cde7-9429-5754-2482-46e1e1db52bd", // Order = 10
            "3988c33d-6e5a-9711-5296-9f5aea951f4d", // Order = 14
            "b97a1bd2-bff5-45b7-aa3e-4c5a21a9a6b8", // Order = 16, disambiguiated by name (F)
            "7e952d63-6dd3-fd02-9263-c40daaabbcec", // Order = 16, disambiguiated by name (S)
            "816a7298-0bda-4769-9982-260faa76cd59", // Order = 20
            "4cdb7187-a323-01db-1374-eddfdff05b81"  // Order = 25
        ]
        
        let actualEntryIdentifiers = generalInformationGroup.orderedKnowledgeEntries.map(\.identifier)
        
        XCTAssertEqual(
            expectedEntryIdentifiers,
            actualEntryIdentifiers,
            "Expected to order knowledge entries within groups by their 'order', disambiguiating by name")
    }
    
}
