@testable import EurofurenceKit
import EurofurenceWebAPI
import XCTest

class RoomTests: EurofurenceKitTestCase {
    
    func testFetchingRoomsSortsThemAlphabetically() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        
        let fetchRequest = Room.alphabeticallySortedFetchRequest()
        let rooms = try scenario.viewContext.fetch(fetchRequest)
        
        let expectedOrderedRoomNames: [String] = [
            "AD Dealers' Den — Convention Hall Section C Level 1",
            "Art Show — Convention Hall Section D",
            "Artist Lounge — Foyer Estrel Hall",
            "Below Rotunda — Food Trucks",
            "Club Stage — Estrel Hall A",
            "ConOps | Frontoffice — Estrel Hall B",
            "Dealers' Den — Convention Hall Section C",
            "ECC Foyer 2 — VR Portal",
            "ECC Foyer 3 — Artist Alley",
            "ECC Room 1",
            "ECC Room 4",
            "ECC Room 5",
            "Entrance Fursuit Lounge — Entrance ECC Room 3",
            "Entrance Rotunda",
            "Estrel Beergarden",
            "Fursuit Lounge — ECC Room 3",
            "Fursuit Photoshoot Registration — Estrel Hall B",
            "Lobby — Atrium",
            "Lyon",
            "Main Stage",
            "Main Stage — Convention Hall Section A",
            "Nizza",
            "Office Passage",
            "Open Stage — ECC Foyer 1",
            "Outdoor",
            "Outdoor — Campfire",
            "Paris",
            "Photoshooting — Convention Hall Section D",
            "Registration — Estrel Hall C",
            "Registration, Con Shop — Paris",
            "Rotunda",
            "Rotunda ",
            "Small Lobby ­— Passage Estrel Hall",
            "Straßburg"
        ]
        
        let actualOrderRoomNames = rooms.map(\.name)
        
        XCTAssertEqual(
            expectedOrderedRoomNames,
            actualOrderRoomNames,
            "Expected to fetch all rooms in alphabetical order"
        )
    }

}
