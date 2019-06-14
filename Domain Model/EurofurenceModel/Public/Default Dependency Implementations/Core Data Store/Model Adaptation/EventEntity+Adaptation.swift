import Foundation

extension EventEntity: EntityAdapting {

    typealias AdaptedType = EventCharacteristics

    static func makeIdentifyingPredicate(for model: EventCharacteristics) -> NSPredicate {
        return NSPredicate(format: "identifier == %@", model.identifier)
    }

    func asAdaptedType() -> EventCharacteristics {
        guard let identifier = identifier,
              let roomIdentifier = roomIdentifier,
              let trackIdentifier = trackIdentifier,
              let dayIdentifier = dayIdentifier,
              let startDateTime = startDateTime,
              let endDateTime = endDateTime,
              let title = title,
              let abstract = abstract,
              let panelHosts = panelHosts,
              let eventDescription = eventDescription else {
            abandonDueToInconsistentState()
        }
        
        return EventCharacteristics(identifier: identifier,
                                    roomIdentifier: roomIdentifier,
                                    trackIdentifier: trackIdentifier,
                                    dayIdentifier: dayIdentifier,
                                    startDateTime: startDateTime as Date,
                                    endDateTime: endDateTime as Date,
                                    title: title,
                                    subtitle: subtitle.defaultingTo(""),
                                    abstract: abstract,
                                    panelHosts: panelHosts,
                                    eventDescription: eventDescription,
                                    posterImageId: posterImageId,
                                    bannerImageId: bannerImageId,
                                    tags: tags,
                                    isAcceptingFeedback: isAcceptingFeedback)
    }

    func consumeAttributes(from value: EventCharacteristics) {
        identifier = value.identifier
        roomIdentifier = value.roomIdentifier
        trackIdentifier = value.trackIdentifier
        dayIdentifier = value.dayIdentifier
        startDateTime = value.startDateTime
        endDateTime = value.endDateTime
        title = value.title
        subtitle = value.subtitle
        abstract = value.abstract
        panelHosts = value.panelHosts
        eventDescription = value.eventDescription
        posterImageId = value.posterImageId
        bannerImageId = value.bannerImageId
        tags = value.tags
        isAcceptingFeedback = value.isAcceptingFeedback
    }

}
