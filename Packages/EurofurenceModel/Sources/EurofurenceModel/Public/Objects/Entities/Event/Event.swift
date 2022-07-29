import Foundation

public typealias EventIdentifier = Identifier<Event>

public protocol Event {

    var identifier: EventIdentifier { get }
    var title: String { get }
    var subtitle: String { get }
    var abstract: String { get }
    var room: Room { get }
    var track: Track { get }
    var hosts: String { get }
    var startDate: Date { get }
    var endDate: Date { get }
    var eventDescription: String { get }
    var posterGraphicPNGData: Data? { get }
    var bannerGraphicPNGData: Data? { get }
    var isSponsorOnly: Bool { get }
    var isSuperSponsorOnly: Bool { get }
    var isArtShow: Bool { get }
    var isKageEvent: Bool { get }
    var isDealersDen: Bool { get }
    var isMainStage: Bool { get }
    var isPhotoshoot: Bool { get }
    var isFaceMaskRequired: Bool { get }
    var isAcceptingFeedback: Bool { get }
    var isFavourite: Bool { get }
    var contentURL: URL { get }

    func add(_ observer: EventObserver)
    func remove(_ observer: EventObserver)
    
    func favourite()
    func unfavourite()
    func prepareFeedback() -> EventFeedback

}
