import EurofurenceModel
import TestUtilities
import XCTest

class EventAssertion: Assertion {
    
    private struct Error: Swift.Error {
        
        var description: String
        
    }

    private let context: EurofurenceSessionTestBuilder.Context
    private let modelCharacteristics: ModelCharacteristics

    init(context: EurofurenceSessionTestBuilder.Context,
         modelCharacteristics: ModelCharacteristics,
         file: StaticString = #file,
         line: UInt = #line) {
        self.context = context
        self.modelCharacteristics = modelCharacteristics

        super.init(file: file, line: line)
    }

    func assertEvents(_ events: [Event], characterisedBy characteristics: [EventCharacteristics]) throws {
        guard events.count == characteristics.count else {
            fail(message: "Differing amount of expected/actual events")
            return
        }
        
        let eventsShouldBeOrderedByStartTime = characteristics.sorted { $0.startDateTime < $1.startDateTime }

        for (idx, event) in events.enumerated() {
            let characteristic = eventsShouldBeOrderedByStartTime[idx]
            try assertEvent(event, characterisedBy: characteristic)
        }
    }

    func assertEvent(_ event: Event?, characterisedBy characteristic: EventCharacteristics) throws {
        guard let event = event else {
            fail(message: "Event not present - expected event \(characteristic.identifier)")
            return
        }

        let rooms = modelCharacteristics.rooms.changed
        guard let expectedRoom = rooms.first(where: { $0.identifier == characteristic.roomIdentifier }) else {
            throw Error(description: "Missing room with ID \(characteristic.roomIdentifier)")
        }
        
        let tracks = modelCharacteristics.tracks.changed
        guard let expectedTrack = tracks.first(where: { $0.identifier == characteristic.trackIdentifier }) else {
            throw Error(description: "Missing track with ID \(characteristic.trackIdentifier)")
        }
        
        let expectedPosterGraphic = context.api.stubbedImage(
            for: characteristic.posterImageId,
            availableImages: modelCharacteristics.images.changed
        )
        
        let expectedBannerGraphic = context.api.stubbedImage(
            for: characteristic.bannerImageId,
            availableImages: modelCharacteristics.images.changed
        )
        
        let tags = characteristic.tags.defaultingTo([])

        assert(event.identifier, isEqualTo: EventIdentifier(characteristic.identifier))
        assert(event.title, isEqualTo: characteristic.title)
        assert(event.subtitle, isEqualTo: characteristic.subtitle)
        assert(event.abstract, isEqualTo: characteristic.abstract)
        assert(event.room.name, isEqualTo: expectedRoom.name)
        assert(event.track.name, isEqualTo: expectedTrack.name)
        assert(event.hosts, isEqualTo: characteristic.panelHosts)
        assert(event.startDate, isEqualTo: characteristic.startDateTime)
        assert(event.endDate, isEqualTo: characteristic.endDateTime)
        assert(event.eventDescription, isEqualTo: characteristic.eventDescription)
        assert(event.isSponsorOnly, isEqualTo: tags.contains("sponsors_only"))
        assert(event.isSuperSponsorOnly, isEqualTo: tags.contains("supersponsors_only"))
        assert(event.isArtShow, isEqualTo: tags.contains("art_show"))
        assert(event.isKageEvent, isEqualTo: tags.contains("kage"))
        assert(event.isDealersDen, isEqualTo: tags.contains("dealers_den"))
        assert(event.isMainStage, isEqualTo: tags.contains("main_stage"))
        assert(event.isPhotoshoot, isEqualTo: tags.contains("photshoot"))

        // TODO: When Event is an entity, should be fetched with a callback and not held in memory
        assert(event.posterGraphicPNGData, isEqualTo: expectedPosterGraphic)
        assert(event.bannerGraphicPNGData, isEqualTo: expectedBannerGraphic)
    }

    func assertCollection<C>(
        _ collection: C,
        containsEventCharacterisedBy characteristic: EventCharacteristics
    ) throws where C: Collection, C.Element == Event {
        guard let event = collection.first(where: { $0.identifier.rawValue == characteristic.identifier }) else {
            fail(message: "Collection did not contain event")
            return
        }

        try assertEvent(event, characterisedBy: characteristic)
    }

}
