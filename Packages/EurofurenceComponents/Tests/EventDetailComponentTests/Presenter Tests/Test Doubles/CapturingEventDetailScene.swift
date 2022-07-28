import EurofurenceModel
import EventDetailComponent
import Foundation
import UIKit.UIViewController

class CapturingEventSummaryComponent: EventSummaryComponent {

    private(set) var capturedTitle: String?
    func setEventTitle(_ title: String) {
        capturedTitle = title
    }

    private(set) var capturedSubtitle: String?
    func setEventSubtitle(_ subtitle: String) {
        capturedSubtitle = subtitle
    }

    private(set) var capturedAbstract: NSAttributedString?
    func setEventAbstract(_ abstract: NSAttributedString) {
        capturedAbstract = abstract
    }

    private(set) var capturedEventStartTime: String?
    func setEventStartEndTime(_ startTime: String) {
        capturedEventStartTime = startTime
    }

    private(set) var capturedEventLocation: String?
    func setEventLocation(_ location: String) {
        capturedEventLocation = location
    }

    private(set) var capturedTrackName: String?
    func setTrackName(_ trackName: String) {
        capturedTrackName = trackName
    }

    private(set) var capturedEventHosts: String?
    func setEventHosts(_ eventHosts: String) {
        capturedEventHosts = eventHosts
    }

}

class CapturingEventDescriptionComponent: EventDescriptionComponent {

    private(set) var capturedEventDescription: NSAttributedString?
    func setEventDescription(_ eventDescription: NSAttributedString) {
        capturedEventDescription = eventDescription
    }

}

class CapturingEventGraphicComponent: EventGraphicComponent {

    private(set) var capturedPNGGraphicData: Data?
    func setPNGGraphicData(_ pngGraphicData: Data) {
        capturedPNGGraphicData = pngGraphicData
    }

}

class CapturingEventInformationBannerComponent: EventInformationBannerComponent {

    private(set) var capturedMessage: String?
    func setBannerMessage(_ message: String) {
        capturedMessage = message
    }

}

class CapturingEventActionBannerComponent: EventActionBannerComponent {
    
    private(set) var capturedTitle: String?
    func setActionTitle(_ title: String) {
        capturedTitle = title
    }
    
    private(set) var selectionHandler: ((Any) -> Void)?
    func setSelectionHandler(_ handler: @escaping (Any) -> Void) {
        selectionHandler = handler
    }
    
    func simulateSelected(_ sender: Any) {
        selectionHandler?(sender)
    }
    
}

class StubEventDetailItemComponentFactory: EventDetailItemComponentFactory {

    let stubbedEventSummaryComponent = CapturingEventSummaryComponent()
    func makeEventSummaryComponent(configuringUsing block: (EventSummaryComponent) -> Void) -> Any {
        block(stubbedEventSummaryComponent)
        return stubbedEventSummaryComponent
    }

    let stubbedEventDescriptionComponent = CapturingEventDescriptionComponent()
    func makeEventDescriptionComponent(configuringUsing block: (EventDescriptionComponent) -> Void) -> Any {
        block(stubbedEventDescriptionComponent)
        return stubbedEventDescriptionComponent
    }

    let stubbedEventGraphicComponent = CapturingEventGraphicComponent()
    func makeEventGraphicComponent(configuringUsing block: (EventGraphicComponent) -> Void) -> Any {
        block(stubbedEventGraphicComponent)
        return stubbedEventGraphicComponent
    }

    let stubbedSponsorsOnlyComponent = CapturingEventInformationBannerComponent()
    func makeSponsorsOnlyBannerComponent(configuringUsing block: (EventInformationBannerComponent) -> Void) -> Any {
        block(stubbedSponsorsOnlyComponent)
        return stubbedSponsorsOnlyComponent
    }

    let stubbedSuperSponsorsOnlyComponent = CapturingEventInformationBannerComponent()
    func makeSuperSponsorsOnlyBannerComponent(
        configuringUsing block: (EventInformationBannerComponent) -> Void
    ) -> Any {
        block(stubbedSuperSponsorsOnlyComponent)
        return stubbedSponsorsOnlyComponent
    }

    let stubbedArtShowMessageComponent = CapturingEventInformationBannerComponent()
    func makeArtShowBannerComponent(configuringUsing block: (EventInformationBannerComponent) -> Void) -> Any {
        block(stubbedArtShowMessageComponent)
        return stubbedArtShowMessageComponent
    }

    let stubbedKageMessageComponent = CapturingEventInformationBannerComponent()
    func makeKageBannerComponent(configuringUsing block: (EventInformationBannerComponent) -> Void) -> Any {
        block(stubbedKageMessageComponent)
        return stubbedKageMessageComponent
    }

    let stubbedDealersDenMessageComponent = CapturingEventInformationBannerComponent()
    func makeDealersDenBannerComponent(configuringUsing block: (EventInformationBannerComponent) -> Void) -> Any {
        block(stubbedDealersDenMessageComponent)
        return stubbedDealersDenMessageComponent
    }

    let stubbedMainStageMessageComponent = CapturingEventInformationBannerComponent()
    func makeMainStageBannerComponent(configuringUsing block: (EventInformationBannerComponent) -> Void) -> Any {
        block(stubbedMainStageMessageComponent)
        return stubbedMainStageMessageComponent
    }

    let stubbedPhotoshootMessageComponent = CapturingEventInformationBannerComponent()
    func makePhotoshootBannerComponent(configuringUsing block: (EventInformationBannerComponent) -> Void) -> Any {
        block(stubbedPhotoshootMessageComponent)
        return stubbedPhotoshootMessageComponent
    }
    
    let stubbedFaceMaskMessageComponent = CapturingEventInformationBannerComponent()
    func makeFaceMaskBannerComponent(configuringUsing block: (EventInformationBannerComponent) -> Void) -> Any {
        block(stubbedFaceMaskMessageComponent)
        return stubbedPhotoshootMessageComponent
    }
    
    let stubbedActionComponent = CapturingEventActionBannerComponent()
    func makeEventActionBannerComponent(configuringUsing block: (EventActionBannerComponent) -> Void) -> Any {
        block(stubbedActionComponent)
        return stubbedActionComponent
    }

}

class CapturingEventDetailScene: UIViewController, EventDetailScene {

    fileprivate var delegate: EventDetailSceneDelegate?
    func setDelegate(_ delegate: EventDetailSceneDelegate) {
        self.delegate = delegate
    }

    fileprivate let componentFactory = StubEventDetailItemComponentFactory()
    fileprivate var binder: EventDetailBinder?
    private(set) var numberOfBoundsComponents: Int?
    func bind(numberOfComponents: Int, using binder: EventDetailBinder) {
        numberOfBoundsComponents = numberOfComponents
        self.binder = binder
    }

}

extension CapturingEventDetailScene {

    var stubbedEventSummaryComponent: CapturingEventSummaryComponent {
        return componentFactory.stubbedEventSummaryComponent
    }

    var stubbedEventDescriptionComponent: CapturingEventDescriptionComponent {
        return componentFactory.stubbedEventDescriptionComponent
    }

    var stubbedEventGraphicComponent: CapturingEventGraphicComponent {
        return componentFactory.stubbedEventGraphicComponent
    }

    var stubbedSponsorsOnlyComponent: CapturingEventInformationBannerComponent {
        return componentFactory.stubbedSponsorsOnlyComponent
    }

    var stubbedSuperSponsorsOnlyComponent: CapturingEventInformationBannerComponent {
        return componentFactory.stubbedSuperSponsorsOnlyComponent
    }

    var stubbedArtShowMessageComponent: CapturingEventInformationBannerComponent {
        return componentFactory.stubbedArtShowMessageComponent
    }

    var stubbedKageMessageComponent: CapturingEventInformationBannerComponent {
        return componentFactory.stubbedKageMessageComponent
    }

    var stubbedDealersDenMessageComponent: CapturingEventInformationBannerComponent {
        return componentFactory.stubbedDealersDenMessageComponent
    }

    var stubbedMainStageMessageComponent: CapturingEventInformationBannerComponent {
        return componentFactory.stubbedMainStageMessageComponent
    }

    var stubbedPhotoshootMessageComponent: CapturingEventInformationBannerComponent {
        return componentFactory.stubbedPhotoshootMessageComponent
    }
    
    var stubbedFaceMaskMessageComponent: CapturingEventInformationBannerComponent {
        return componentFactory.stubbedFaceMaskMessageComponent
    }
    
    var stubbedActionComponent: CapturingEventActionBannerComponent {
        return componentFactory.stubbedActionComponent
    }

    func simulateSceneDidLoad() {
        delegate?.eventDetailSceneDidLoad()
    }
    
    func simulateSceneDidAppear() {
        delegate?.eventDetailSceneDidAppear()
    }
    
    func simulateSceneDidDisappear() {
        delegate?.eventDetailSceneDidDisappear()
    }

    @discardableResult
    func bindComponent(at indexPath: IndexPath) -> Any? {
        return binder?.bindComponent(at: indexPath, using: componentFactory)
    }

}
