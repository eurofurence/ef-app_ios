import EurofurenceWebAPI
@testable import EurofurenceKit
import XCTest

class TrackTests: EurofurenceKitTestCase {

    func testFetchingTracksSortsThemAlphabetically() async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        
        let fetchRequest = Track.alphabeticallySortedFetchRequest()
        let tracks = try scenario.viewContext.fetch(fetchRequest)
        
        let expectedOrderedTrackNames: [String] = [
            "Animation",
            "Art Show",
            "Charity",
            "Creating Art",
            "Dance",
            "Dealers' Den",
            "Fursuit",
            "Games | Social",
            "Guest of Honor",
            "Lobby and Outdoor",
            "Maker ∕ Theme-based Fursuit Group Photo",
            "Misc.",
            "Music",
            "Performance",
            "Stage",
            "Supersponsor Event",
            "Writing"
        ]
        
        let actualOrderedTrackNames = tracks.map(\.name)
        
        XCTAssertEqual(expectedOrderedTrackNames, actualOrderedTrackNames, "Expected to sort tracks alphabetically")
    }

}
