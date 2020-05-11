import EurofurenceModel
import Foundation.NSIndexPath
import UIKit.UIImage

public protocol NewsViewModel {

    var numberOfComponents: Int { get }

    func numberOfItemsInComponent(at index: Int) -> Int
    func titleForComponent(at index: Int) -> String
    func describeComponent(at indexPath: IndexPath, to visitor: NewsViewModelVisitor)
    func fetchModelValue(at indexPath: IndexPath, completionHandler: @escaping (NewsViewModelValue) -> Void)

}

public enum NewsViewModelValue {
    case messages
    case announcement(AnnouncementIdentifier)
    case allAnnouncements
    case event(Event)
}

public protocol NewsViewModelVisitor {

    func visit(_ userWidget: UserWidgetComponentViewModel)
    func visit(_ countdown: ConventionCountdownComponentViewModel)
    func visit(_ announcement: AnnouncementItemViewModel)
    func visit(_ viewAllAnnouncements: ViewAllAnnouncementsComponentViewModel)
    func visit(_ event: EventComponentViewModel)

}

public struct ConventionCountdownComponentViewModel: Hashable {

    public var timeUntilConvention: String
    
    public init(timeUntilConvention: String) {
        self.timeUntilConvention = timeUntilConvention
    }

}

public struct AnnouncementItemViewModel: Hashable {

    public var title: String
    public var detail: NSAttributedString
    public var receivedDateTime: String
    public var isRead: Bool
    
    public init(
        title: String,
        detail: NSAttributedString, 
        receivedDateTime: String,
        isRead: Bool
    ) {
        self.title = title
        self.detail = detail
        self.receivedDateTime = receivedDateTime
        self.isRead = isRead
    }

}

public struct ViewAllAnnouncementsComponentViewModel: Hashable {

    public var caption: String
    
    public init(caption: String) {
        self.caption = caption
    }

}

public struct EventComponentViewModel: Hashable {

    public var startTime: String
    public var endTime: String
    public var eventName: String
    public var location: String
    public var isSponsorEvent: Bool
    public var isSuperSponsorEvent: Bool
    public var isFavourite: Bool
    public var isArtShowEvent: Bool
    public var isKageEvent: Bool
    public var isDealersDenEvent: Bool
    public var isMainStageEvent: Bool
    public var isPhotoshootEvent: Bool
    
    public init(
        startTime: String,
        endTime: String,
        eventName: String,
        location: String,
        isSponsorEvent: Bool,
        isSuperSponsorEvent: Bool,
        isFavourite: Bool,
        isArtShowEvent: Bool,
        isKageEvent: Bool,
        isDealersDenEvent: Bool,
        isMainStageEvent: Bool,
        isPhotoshootEvent: Bool
    ) {
        self.startTime = startTime
        self.endTime = endTime
        self.eventName = eventName
        self.location = location
        self.isSponsorEvent = isSponsorEvent
        self.isSuperSponsorEvent = isSuperSponsorEvent
        self.isFavourite = isFavourite
        self.isArtShowEvent = isArtShowEvent
        self.isKageEvent = isKageEvent
        self.isDealersDenEvent = isDealersDenEvent
        self.isMainStageEvent = isMainStageEvent
        self.isPhotoshootEvent = isPhotoshootEvent
    }

}

public struct UserWidgetComponentViewModel: Hashable {

    public var prompt: String
    public var detailedPrompt: String
    public var hasUnreadMessages: Bool
    
    public init(
        prompt: String,
        detailedPrompt: String,
        hasUnreadMessages: Bool
    ) {
        self.prompt = prompt
        self.detailedPrompt = detailedPrompt
        self.hasUnreadMessages = hasUnreadMessages
    }

}
