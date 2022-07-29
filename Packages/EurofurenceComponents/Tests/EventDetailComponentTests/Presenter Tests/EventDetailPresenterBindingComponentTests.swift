import EurofurenceModel
import EventDetailComponent
import TestUtilities
import XCTest
import XCTEurofurenceModel

class EventDetailPresenterBindingComponentTests: XCTestCase {
    
    func tetsBindingBanner() {
        let event = FakeEvent.random
        let graphic = EventGraphicViewModel.random
        let index = Int.random
        let viewModel = StubEventGraphicViewModel(graphic: graphic, at: index)
        let viewModelFactory = FakeEventDetailViewModelFactory(viewModel: viewModel, for: event)
        let context = EventDetailPresenterTestBuilder().with(viewModelFactory).build(for: event)
        context.simulateSceneDidLoad()
        let boundComponent = context.scene.bindComponent(at: IndexPath(item: index, section: 0))
        let eventGraphicComponent = boundComponent as? CapturingEventGraphicComponent

        XCTAssertTrue(eventGraphicComponent === context.scene.stubbedEventGraphicComponent)
        XCTAssertEqual(graphic.pngGraphicData, context.scene.stubbedEventGraphicComponent.capturedPNGGraphicData)
    }

    func testBindingDescription() {
        let event = FakeEvent.random
        let eventDescription = EventDescriptionViewModel.random
        let index = Int.random
        let viewModel = StubEventDescriptionViewModel(eventDescription: eventDescription, at: index)
        let viewModelFactory = FakeEventDetailViewModelFactory(viewModel: viewModel, for: event)
        let context = EventDetailPresenterTestBuilder().with(viewModelFactory).build(for: event)
        context.simulateSceneDidLoad()
        let boundComponent = context.scene.bindComponent(at: IndexPath(item: index, section: 0))
        let eventDescriptionComponent = boundComponent as? CapturingEventDescriptionComponent
        let stubbedComponent = context.scene.stubbedEventDescriptionComponent
        
        XCTAssertTrue(eventDescriptionComponent === stubbedComponent)
        XCTAssertEqual(eventDescription.contents, stubbedComponent.capturedEventDescription)
    }
    
    func testBindingSummaryComponent() {
        let summary = EventSummaryViewModel.random
        let viewModel = StubEventSummaryViewModel(summary: summary)
        let scene = prepareSceneForBindingComponent(viewModel: viewModel)
        let eventSummaryComponent = scene.stubbedEventSummaryComponent
        
        XCTAssertEqual(viewModel.numberOfComponents, scene.numberOfBoundsComponents)
        XCTAssertEqual(summary.title, eventSummaryComponent.capturedTitle)
        XCTAssertEqual(summary.subtitle, eventSummaryComponent.capturedSubtitle)
        XCTAssertEqual(summary.abstract, eventSummaryComponent.capturedAbstract)
        XCTAssertEqual(summary.eventStartEndTime, eventSummaryComponent.capturedEventStartTime)
        XCTAssertEqual(summary.location, eventSummaryComponent.capturedEventLocation)
        XCTAssertEqual(summary.trackName, eventSummaryComponent.capturedTrackName)
        XCTAssertEqual(summary.eventHosts, eventSummaryComponent.capturedEventHosts)
    }
    
    func tetsBindingKageMessage() {
        let message = String.random
        let kageMessageViewModel = EventKageMessageViewModel(message: message)
        let viewModel = StubKageEventViewModel(kageMessageViewModel: kageMessageViewModel)
        let scene = prepareSceneForBindingComponent(viewModel: viewModel)

        XCTAssertEqual(message, scene.stubbedKageMessageComponent.capturedMessage)
    }
    
    func testBindingMainStage() {
        let message = String.random
        let kageMessageViewModel = EventMainStageMessageViewModel(message: message)
        let viewModel = StubMainStageEventViewModel(mainStageMessageViewModel: kageMessageViewModel)
        let scene = prepareSceneForBindingComponent(viewModel: viewModel)

        XCTAssertEqual(message, scene.stubbedMainStageMessageComponent.capturedMessage)
    }
    
    func testBindingPhotoshoot() {
        let message = String.random
        let kageMessageViewModel = EventPhotoshootMessageViewModel(message: message)
        let viewModel = StubPhotoshootEventViewModel(photoshootMessageViewModel: kageMessageViewModel)
        let scene = prepareSceneForBindingComponent(viewModel: viewModel)

        XCTAssertEqual(message, scene.stubbedPhotoshootMessageComponent.capturedMessage)
    }
    
    func testBindingSponsorsOnly() {
        let message = String.random
        let sponsorsOnlyViewModel = EventSponsorsOnlyWarningViewModel(message: message)
        let viewModel = StubSponsorsOnlyEventViewModel(sponsorsOnlyWarningViewModel: sponsorsOnlyViewModel)
        let scene = prepareSceneForBindingComponent(viewModel: viewModel)

        XCTAssertEqual(message, scene.stubbedSponsorsOnlyComponent.capturedMessage)
    }
    
    func testBindingSuperSponsorsOnly() {
        let message = String.random
        let superSponsorsOnlyWarningViewModel = EventSuperSponsorsOnlyWarningViewModel(message: message)
        let viewModel = StubSuperSponsorsOnlyEventViewModel(
            superSponsorsOnlyWarningViewModel: superSponsorsOnlyWarningViewModel
        )
        
        let scene = prepareSceneForBindingComponent(viewModel: viewModel)

        XCTAssertEqual(message, scene.stubbedSuperSponsorsOnlyComponent.capturedMessage)
    }
    
    func testBindingDealersDen() {
        let message = String.random
        let artShowViewModel = EventDealersDenMessageViewModel(message: message)
        let viewModel = StubDealersDenEventViewModel(dealersDenMessageViewModel: artShowViewModel)
        let scene = prepareSceneForBindingComponent(viewModel: viewModel)

        XCTAssertEqual(message, scene.stubbedDealersDenMessageComponent.capturedMessage)
    }
    
    func testBindingArtShow() {
        let message = String.random
        let artShowViewModel = EventArtShowMessageViewModel(message: message)
        let viewModel = StubArtShowEventViewModel(artShowMessageViewModel: artShowViewModel)
        let scene = prepareSceneForBindingComponent(viewModel: viewModel)
        
        XCTAssertEqual(message, scene.stubbedArtShowMessageComponent.capturedMessage)
    }
    
    func testBindingFaceMaskRequired() {
        let message = String.random
        let faceMaskViewModel = EventFaceMaskMessageViewModel(message: message)
        let viewModel = StubFaceMaskEventViewModel(faceMaskMessageViewModel: faceMaskViewModel)
        let scene = prepareSceneForBindingComponent(viewModel: viewModel)
        
        XCTAssertEqual(message, scene.stubbedFaceMaskMessageComponent.capturedMessage)
    }
    
    private func prepareSceneForBindingComponent(
        viewModel: EventDetailViewModel
    ) -> CapturingEventDetailScene {
        let event = FakeEvent.random
        let viewModelFactory = FakeEventDetailViewModelFactory(viewModel: viewModel, for: event)
        let context = EventDetailPresenterTestBuilder().with(viewModelFactory).build(for: event)
        context.simulateSceneDidLoad()
        context.scene.bindComponent(at: IndexPath(item: 0, section: 0))
        
        return context.scene
    }

}

struct StubFaceMaskEventViewModel: EventDetailViewModel {

    var faceMaskMessageViewModel: EventFaceMaskMessageViewModel

    var numberOfComponents: Int { return 1 }
    func setDelegate(_ delegate: EventDetailViewModelDelegate) { }
    
    func describe(componentAt index: Int, to visitor: EventDetailViewModelVisitor) {
        visitor.visit(faceMaskMessageViewModel)
    }
    
    func favourite() { }
    func unfavourite() { }

}
