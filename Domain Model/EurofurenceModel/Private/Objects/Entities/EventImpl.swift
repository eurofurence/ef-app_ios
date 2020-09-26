import EventBus
import Foundation

class EventImpl: Event {

    private let eventBus: EventBus
    private let imageCache: ImagesCache
    private let shareableURLFactory: ShareableURLFactory
    private let posterImageId: String?
    private let bannerImageId: String?

    var posterGraphicPNGData: Data? {
        return posterImageId.let(imageCache.cachedImageData)
    }
    
    var bannerGraphicPNGData: Data? {
        return bannerImageId.let(imageCache.cachedImageData)
    }
    
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
    var isSponsorOnly: Bool
    var isSuperSponsorOnly: Bool
    var isArtShow: Bool
    var isKageEvent: Bool
    var isDealersDen: Bool
    var isMainStage: Bool
    var isPhotoshoot: Bool
    var isAcceptingFeedback: Bool
    var day: ConferenceDayCharacteristics

    init(eventBus: EventBus,
         imageCache: ImagesCache,
         shareableURLFactory: ShareableURLFactory,
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
         posterImageId: String?,
         bannerImageId: String?,
         isSponsorOnly: Bool,
         isSuperSponsorOnly: Bool,
         isArtShow: Bool,
         isKageEvent: Bool,
         isDealersDen: Bool,
         isMainStage: Bool,
         isPhotoshoot: Bool,
         isAcceptingFeedback: Bool,
         day: ConferenceDayCharacteristics) {
        self.eventBus = eventBus
        self.imageCache = imageCache
        self.shareableURLFactory = shareableURLFactory
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
        self.posterImageId = posterImageId
        self.bannerImageId = bannerImageId
        self.isSponsorOnly = isSponsorOnly
        self.isSuperSponsorOnly = isSuperSponsorOnly
        self.isArtShow = isArtShow
        self.isKageEvent = isKageEvent
        self.isDealersDen = isDealersDen
        self.isMainStage = isMainStage
        self.isPhotoshoot = isPhotoshoot
        self.isAcceptingFeedback = isAcceptingFeedback
        
        self.day = day
    }
    
    var contentURL: URL {
        return shareableURLFactory.makeURL(for: identifier)
    }

    private var observers: [EventObserver] = []
    func add(_ observer: EventObserver) {
        observers.append(observer)
        provideFavouritedStateToObserver(observer)
    }
    
    func remove(_ observer: EventObserver) {
        observers.removeAll(where: { $0 === observer })
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
    
    func prepareFeedback() -> EventFeedback {
        if isAcceptingFeedback {
            return AcceptingEventFeedback(eventBus: eventBus, eventIdentifier: identifier)
        } else {
            return NotAcceptingEventFeedback()
        }
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
