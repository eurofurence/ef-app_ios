import CoreData
@testable import EurofurenceKit
import XCTest

class WellKnownTrackTests: XCTestCase {
    
    func testArtShow() async throws {
        try await assertTrack(named: "Art Show", hasCanonicalTrack: .artShow)
    }
    
    func testCharity() async throws {
        try await assertTrack(named: "Charity", hasCanonicalTrack: .charity)
    }
    
    func testCreatingArt() async throws {
        try await assertTrack(named: "Creating Art", hasCanonicalTrack: .creatingArt)
    }
    
    func testDealersDen() async throws {
        try await assertTrack(named: "Dealers' Den", hasCanonicalTrack: .dealersDen)
    }
    
    func testFursuit() async throws {
        try await assertTrack(named: "Fursuit", hasCanonicalTrack: .fursuit)
    }
    
    func testGamesAndSocial() async throws {
        try await assertTrack(named: "Games | Social", hasCanonicalTrack: .gamesAndSocial)
    }
    
    func testGuestOfHonour() async throws {
        try await assertTrack(named: "Guest of Honor", hasCanonicalTrack: .guestOfHonour)
    }
    
    func testLobbyAndOutdoor() async throws {
        try await assertTrack(named: "Lobby and Outdoor", hasCanonicalTrack: .lobbyAndOutdoor)
    }
    
    func testMisc() async throws {
        try await assertTrack(named: "Misc.", hasCanonicalTrack: .miscellaneous)
    }
    
    func testMusic() async throws {
        try await assertTrack(named: "Music", hasCanonicalTrack: .music)
    }
    
    func testPerformance() async throws {
        try await assertTrack(named: "Performance", hasCanonicalTrack: .performance)
    }
    
    func testStage() async throws {
        try await assertTrack(named: "Stage", hasCanonicalTrack: .mainStage)
    }
    
    func testSuperSponsorEvent() async throws {
        try await assertTrack(named: "Supersponsor Event", hasCanonicalTrack: .supersponsor)
    }
    
    func testWriting() async throws {
        try await assertTrack(named: "Writing", hasCanonicalTrack: .writing)
    }
    
    func testAnimation() async throws {
        try await assertTrack(named: "Animation", hasCanonicalTrack: .animation)
    }
    
    func testDance() async throws {
        try await assertTrack(named: "Dance", hasCanonicalTrack: .dance)
    }
    
    func testFursuitGroupPhoto() async throws {
        try await assertTrack(named: "Maker ∕ Theme-based Fursuit Group Photo", hasCanonicalTrack: .fursuitGroupPhoto)
    }
    
    private func assertTrack(
        named name: String,
        hasCanonicalTrack expected: CanonicalTrack,
        line: UInt = #line
    ) async throws {
        let scenario = await EurofurenceModelTestBuilder().build()
        try await scenario.updateLocalStore(using: .ef26)
        let track = try self.track(named: name, in: scenario.viewContext)
        
        XCTAssertEqual(track.canonicalTrack, expected, line: line)
    }
    
    private func track(named name: String, in managedObjectContext: NSManagedObjectContext) throws -> Track {
        let fetchRequest: NSFetchRequest<Track> = Track.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        fetchRequest.fetchLimit = 1
        
        let matches = try managedObjectContext.fetch(fetchRequest)
        return try XCTUnwrap(matches.first)
    }

}
