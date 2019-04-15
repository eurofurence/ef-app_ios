import Foundation

public typealias EventIdentifier = Identifier<Event>

public protocol EventObserver {

    func eventDidBecomeFavourite(_ event: Event)
    func eventDidBecomeUnfavourite(_ event: Event)

}

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

    func add(_ observer: EventObserver)
    func favourite()
    func unfavourite()
    func prepareFeedback() -> EventFeedback

}

public protocol EventFeedback {
    
    var feedback: String { get set }
    var rating: Int { get set }
    
    func submit(_ delegate: EventFeedbackDelegate)
    
}

public protocol EventFeedbackDelegate {
    
    func eventFeedbackDidSubmitSuccessfully(_ feedback: EventFeedback)
    
}
