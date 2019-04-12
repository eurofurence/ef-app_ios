import EurofurenceModel
import Foundation
import TestUtilities

public extension ModelCharacteristics {
    
    static let testConventionIdentifier = "TEST_CONVENTION"
    
    static var randomWithoutDeletions: ModelCharacteristics {
        let knowledge = KnowledgeGroupCharacteristics.makeRandomGroupsAndEntries()
        let rooms = [RoomCharacteristics].random
        let tracks = [TrackCharacteristics].random
        let days = [ConferenceDayCharacteristics].random
        let events = (0...Int.random(upperLimit: 3) + 2).map { (_) -> EventCharacteristics in
            let eventStartTime: Date = .random
            return EventCharacteristics(identifier: .random,
                                        roomIdentifier: rooms.randomElement().element.identifier,
                                        trackIdentifier: tracks.randomElement().element.identifier,
                                        dayIdentifier: days.randomElement().element.identifier,
                                        startDateTime: eventStartTime,
                                        endDateTime: eventStartTime.addingTimeInterval(.random),
                                        title: .random,
                                        subtitle: .random,
                                        abstract: .random,
                                        panelHosts: .random,
                                        eventDescription: .random,
                                        posterImageId: .random,
                                        bannerImageId: .random,
                                        tags: .random)
        }
        
        let dealers: ModelCharacteristics.Update<DealerCharacteristics> = ModelCharacteristics.Update(changed: .random)
        let maps: ModelCharacteristics.Update<MapCharacteristics> = ModelCharacteristics.Update(changed: .random)
        
        let makeImageFromIdentifier: (String) -> ImageCharacteristics = { (identifier) in
            return ImageCharacteristics(identifier: identifier, internalReference: "", contentHashSha1: .random)
        }
        
        var allImages: [ImageCharacteristics] = events.compactMap({ $0.bannerImageId }).map(makeImageFromIdentifier)
        allImages.append(contentsOf: events.compactMap({ $0.posterImageId }).map(makeImageFromIdentifier))
        allImages.append(contentsOf: dealers.changed.compactMap({ $0.artistImageId }).map(makeImageFromIdentifier))
        allImages.append(contentsOf: dealers.changed.compactMap({ $0.artistThumbnailImageId }).map(makeImageFromIdentifier))
        allImages.append(contentsOf: dealers.changed.compactMap({ $0.artPreviewImageId }).map(makeImageFromIdentifier))
        allImages.append(contentsOf: maps.changed.map({ $0.imageIdentifier }).map(makeImageFromIdentifier))
        
        let knowledgeEntryImages = knowledge.entries.reduce([String](), { $0 + $1.imageIdentifiers })
        let knowledgeEntryAPIImages = knowledgeEntryImages.map(makeImageFromIdentifier)
        allImages.append(contentsOf: knowledgeEntryAPIImages)
        
        let announcements = [AnnouncementCharacteristics].random
        let announcementImages = announcements.compactMap({ $0.imageIdentifier }).map(makeImageFromIdentifier)
        allImages.append(contentsOf: announcementImages)
        
        return ModelCharacteristics(conventionIdentifier: testConventionIdentifier,
                                    knowledgeGroups: ModelCharacteristics.Update(changed: knowledge.groups),
                                    knowledgeEntries: ModelCharacteristics.Update(changed: knowledge.entries),
                                    announcements: ModelCharacteristics.Update(changed: announcements),
                                    events: ModelCharacteristics.Update(changed: events),
                                    rooms: ModelCharacteristics.Update(changed: rooms),
                                    tracks: ModelCharacteristics.Update(changed: tracks),
                                    conferenceDays: ModelCharacteristics.Update(changed: days),
                                    dealers: dealers,
                                    maps: maps,
                                    images: ModelCharacteristics.Update(changed: allImages))
    }
    
}
