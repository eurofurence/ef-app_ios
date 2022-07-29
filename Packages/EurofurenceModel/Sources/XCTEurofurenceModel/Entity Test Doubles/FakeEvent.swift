import EurofurenceModel
import Foundation
import TestUtilities

public final class FakeEvent: Event {

    public enum FavouritedState {
        case unset
        case favourited
        case unfavourited
    }

    public var identifier: EventIdentifier
    public var title: String
    public var subtitle: String
    public var abstract: String
    public var room: Room
    public var track: Track
    public var hosts: String
    public var startDate: Date
    public var endDate: Date
    public var eventDescription: String
    public var posterGraphicPNGData: Data?
    public var bannerGraphicPNGData: Data?
    public var isSponsorOnly: Bool
    public var isSuperSponsorOnly: Bool
    public var isArtShow: Bool
    public var isKageEvent: Bool
    public var isDealersDen: Bool
    public var isMainStage: Bool
    public var isPhotoshoot: Bool
    public var isAcceptingFeedback: Bool
    public var isFavourite: Bool
    public var isFaceMaskRequired: Bool

    public init(
        identifier: EventIdentifier,
        title: String,
        subtitle: String,
        abstract: String,
        room: Room,
        track: Track,
        hosts: String,
        startDate: Date,
        endDate: Date,
        eventDescription: String,
        posterGraphicPNGData: Data?,
        bannerGraphicPNGData: Data?,
        isSponsorOnly: Bool,
        isSuperSponsorOnly: Bool,
        isArtShow: Bool,
        isKageEvent: Bool,
        isDealersDen: Bool,
        isMainStage: Bool,
        isPhotoshoot: Bool,
        isAcceptingFeedback: Bool,
        isFavourite: Bool,
        isFaceMaskRequired: Bool
    ) {
        self.identifier = identifier
        self.title = title
        self.subtitle = subtitle
        self.abstract = abstract
        self.room = room
        self.track = track
        self.hosts = hosts
        self.startDate = startDate
        self.endDate = endDate
        self.eventDescription = eventDescription
        self.posterGraphicPNGData = posterGraphicPNGData
        self.bannerGraphicPNGData = bannerGraphicPNGData
        self.isSponsorOnly = isSponsorOnly
        self.isSuperSponsorOnly = isSuperSponsorOnly
        self.isArtShow = isArtShow
        self.isKageEvent = isKageEvent
        self.isDealersDen = isDealersDen
        self.isMainStage = isMainStage
        self.isPhotoshoot = isPhotoshoot
        self.isAcceptingFeedback = isAcceptingFeedback
        self.isFavourite = isFavourite
        self.isFaceMaskRequired = isFaceMaskRequired

        favouritedState = .unset
    }

    private var observers: [EventObserver] = []
    public func add(_ observer: EventObserver) {
        observers.append(observer)
        notifyObserverOfCurrentFavouriteStateAsPerEventContract(observer)
    }
    
    public func remove(_ observer: EventObserver) {
        observers.removeAll(where: { $0 === observer })
    }

    public private(set) var favouritedState: FavouritedState
    public func favourite() {
        isFavourite = true
        favouritedState = .favourited
        observers.forEach({ $0.eventDidBecomeFavourite(self) })
    }

    public func unfavourite() {
        isFavourite = false
        favouritedState = .unfavourited
        observers.forEach({ $0.eventDidBecomeUnfavourite(self) })
    }
    
    public var feedbackToReturn: FakeEventFeedback?
    public private(set) var lastGeneratedFeedback: FakeEventFeedback?
    public func prepareFeedback() -> EventFeedback {
        let feedback = feedbackToReturn ?? FakeEventFeedback()
        lastGeneratedFeedback = feedback
        
        return feedback
    }
    
    public let shareableURL = URL.random
    public var contentURL: URL {
        return shareableURL
    }

    private func notifyObserverOfCurrentFavouriteStateAsPerEventContract(_ observer: EventObserver) {
        if favouritedState == .favourited {
            observer.eventDidBecomeFavourite(self)
        } else {
            observer.eventDidBecomeUnfavourite(self)
        }
    }

}

public class FakeEventFeedback: EventFeedback {
    
    public enum State {
        case unset
        case submitted
    }
    
    public private(set) var state: State = .unset
    
    public var feedback: String
    public var starRating: Int
    
    public init(rating: Int = 0) {
        feedback = ""
        self.starRating = rating
    }
    
    private var delegate: EventFeedbackDelegate?
    public func submit(_ delegate: EventFeedbackDelegate) {
        state = .submitted
        self.delegate = delegate
    }
    
    public func simulateSuccess() {
        delegate?.eventFeedbackSubmissionDidFinish(self)
    }
    
    public func simulateFailure() {
        delegate?.eventFeedbackSubmissionDidFail(self)
    }
    
}

extension FakeEvent: RandomValueProviding {

    public static var random: FakeEvent {
        let startDate = Date.random
        return FakeEvent(
            identifier: .random,
            title: .random,
            subtitle: .random,
            abstract: .random,
            room: .random,
            track: .random,
            hosts: .random,
            startDate: startDate,
            endDate: startDate.addingTimeInterval(.random),
            eventDescription: .random,
            posterGraphicPNGData: .random,
            bannerGraphicPNGData: .random,
            isSponsorOnly: .random,
            isSuperSponsorOnly: .random,
            isArtShow: .random,
            isKageEvent: .random,
            isDealersDen: .random,
            isMainStage: .random,
            isPhotoshoot: .random,
            isAcceptingFeedback: .random,
            isFavourite: .random,
            isFaceMaskRequired: .random
        )
    }
    
    public static var randomStandardEvent: FakeEvent {
        let event = FakeEvent.random
        event.isSponsorOnly = false
        event.isSuperSponsorOnly = false
        event.isArtShow = false
        event.isKageEvent = false
        event.isMainStage = false
        event.isPhotoshoot = false
        event.isDealersDen = false

        return event
    }

}
