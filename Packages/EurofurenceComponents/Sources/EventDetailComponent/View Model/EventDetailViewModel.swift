import Foundation

public protocol EventDetailViewModel {

    var numberOfComponents: Int { get }
    func setDelegate(_ delegate: EventDetailViewModelDelegate)
    func describe(componentAt index: Int, to visitor: EventDetailViewModelVisitor)

}

public protocol EventDetailViewModelDelegate: AnyObject {

    func eventFavourited()
    func eventUnfavourited()
    func leaveFeedback()

}

public protocol EventDetailViewModelVisitor {

    func visit(_ summary: EventSummaryViewModel)
    func visit(_ description: EventDescriptionViewModel)
    func visit(_ graphic: EventGraphicViewModel)
    func visit(_ sponsorsOnlyMessage: EventSponsorsOnlyWarningViewModel)
    func visit(_ superSponsorsOnlyMessage: EventSuperSponsorsOnlyWarningViewModel)
    func visit(_ artShowMessage: EventArtShowMessageViewModel)
    func visit(_ kageMessage: EventKageMessageViewModel)
    func visit(_ dealersDenMessage: EventDealersDenMessageViewModel)
    func visit(_ mainStageMessage: EventMainStageMessageViewModel)
    func visit(_ photoshootMessage: EventPhotoshootMessageViewModel)
    func visit(_ faceMaskMessage: EventFaceMaskMessageViewModel)
    func visit(_ actionViewModel: EventActionViewModel)

}

public struct EventSummaryViewModel: Equatable {

    public var title: String
    public var subtitle: String
    public var abstract: NSAttributedString
    public var eventStartEndTime: String
    public var location: String
    public var trackName: String
    public var eventHosts: String
    
    public init(
        title: String,
        subtitle: String,
        abstract: NSAttributedString,
        eventStartEndTime: String,
        location: String,
        trackName: String,
        eventHosts: String
    ) {
        self.title = title
        self.subtitle = subtitle
        self.abstract = abstract
        self.eventStartEndTime = eventStartEndTime
        self.location = location
        self.trackName = trackName
        self.eventHosts = eventHosts
    }

}

public struct EventDescriptionViewModel: Equatable {

    public var contents: NSAttributedString
    
    public init(contents: NSAttributedString) {
        self.contents = contents
    }

}

public struct EventGraphicViewModel: Equatable {

    public var pngGraphicData: Data
    
    public init(pngGraphicData: Data) {
        self.pngGraphicData = pngGraphicData
    }

}

public struct EventSponsorsOnlyWarningViewModel: Equatable {

    public var message: String
    
    public init(message: String) {
        self.message = message
    }

}

public struct EventSuperSponsorsOnlyWarningViewModel: Equatable {

    public var message: String
    
    public init(message: String) {
        self.message = message
    }

}

public struct EventArtShowMessageViewModel: Equatable {

    public var message: String
    
    public init(message: String) {
        self.message = message
    }

}

public struct EventKageMessageViewModel: Equatable {

    public var message: String
    
    public init(message: String) {
        self.message = message
    }

}

public struct EventDealersDenMessageViewModel: Equatable {

    public var message: String
    
    public init(message: String) {
        self.message = message
    }

}

public struct EventMainStageMessageViewModel: Equatable {

    public var message: String
    
    public init(message: String) {
        self.message = message
    }

}

public struct EventPhotoshootMessageViewModel: Equatable {

    public var message: String
    
    public init(message: String) {
        self.message = message
    }

}

public struct EventFaceMaskMessageViewModel: Equatable {
    
    public var message: String
    
    public init(message: String) {
        self.message = message
    }
    
}

public protocol EventActionViewModel: AnyObject {
    
    func describe(to visitor: EventActionViewModelVisitor)
    func perform(sender: Any?)
    
}

extension EventActionViewModel {
    
    public func perform() {
        perform(sender: nil)
    }
    
}

public protocol EventActionViewModelVisitor {
    
    func visitActionTitle(_ actionTitle: String)
    
}
