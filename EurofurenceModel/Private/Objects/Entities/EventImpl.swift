import EventBus
import Foundation

class EventImpl: Event {

    private let eventBus: EventBus

    var identifier: EventIdentifier
    var title: String
    var subtitle: String
    var abstract: String
    var room: Room
    var track: Track
    var hosts: String
    var startDate: Date
    var endDate: Date
    var eventDescription: String
    var posterGraphicPNGData: Data?
    var bannerGraphicPNGData: Data?
    var isSponsorOnly: Bool
    var isSuperSponsorOnly: Bool
    var isArtShow: Bool
    var isKageEvent: Bool
    var isDealersDen: Bool
    var isMainStage: Bool
    var isPhotoshoot: Bool

    init(eventBus: EventBus,
         isFavourite: Bool,
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
         isPhotoshoot: Bool) {
        self.eventBus = eventBus
        self.isFavourite = isFavourite

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
    }

    private var observers: [EventObserver] = []
    func add(_ observer: EventObserver) {
        observers.append(observer)
        provideFavouritedStateToObserver(observer)
    }

    private var isFavourite: Bool {
        didSet {
            postFavouriteStateChangedEvent()
        }
    }

    func favourite() {
        isFavourite = true
        notifyObserversFavouritedStateDidChange()
    }

    func unfavourite() {
        isFavourite = false
        notifyObserversFavouritedStateDidChange()
    }

    private func notifyObserversFavouritedStateDidChange() {
        observers.forEach(provideFavouritedStateToObserver)
    }

    private func provideFavouritedStateToObserver(_ observer: EventObserver) {
        if isFavourite {
            observer.eventDidBecomeFavourite(self)
        } else {
            observer.eventDidBecomeUnfavourite(self)
        }
    }

    private func postFavouriteStateChangedEvent() {
        let event: Any
        if isFavourite {
            event = DomainEvent.FavouriteEvent(identifier: identifier)
        } else {
            event = DomainEvent.UnfavouriteEvent(identifier: identifier)
        }

        eventBus.post(event)
    }

}
