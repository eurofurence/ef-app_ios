import Foundation

protocol EventDetailViewModel {

    var numberOfComponents: Int { get }
    func setDelegate(_ delegate: EventDetailViewModelDelegate)
    func describe(componentAt index: Int, to visitor: EventDetailViewModelVisitor)

}

protocol EventDetailViewModelDelegate {

    func eventFavourited()
    func eventUnfavourited()

}

protocol EventDetailViewModelVisitor {

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
    func visit(_ actionViewModel: EventActionViewModel)

}

struct EventSummaryViewModel: Equatable {

    var title: String
    var subtitle: String
    var abstract: NSAttributedString
    var eventStartEndTime: String
    var location: String
    var trackName: String
    var eventHosts: String

}

struct EventDescriptionViewModel: Equatable {

    var contents: NSAttributedString

}

struct EventGraphicViewModel: Equatable {

    var pngGraphicData: Data

}

struct EventSponsorsOnlyWarningViewModel: Equatable {

    var message: String

}

struct EventSuperSponsorsOnlyWarningViewModel: Equatable {

    var message: String

}

struct EventArtShowMessageViewModel: Equatable {

    var message: String

}

struct EventKageMessageViewModel: Equatable {

    var message: String

}

struct EventDealersDenMessageViewModel: Equatable {

    var message: String

}

struct EventMainStageMessageViewModel: Equatable {

    var message: String

}

struct EventPhotoshootMessageViewModel: Equatable {

    var message: String

}

protocol EventActionViewModel {
    
    func describe(to visitor: EventActionViewModelVisitor)
    func perform()
    
}

protocol EventActionViewModelVisitor {
    
    func visitActionTitle(_ actionTitle: String)
    
}
