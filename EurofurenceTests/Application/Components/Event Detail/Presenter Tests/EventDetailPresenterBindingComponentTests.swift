import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import TestUtilities
import XCTest

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

        XCTAssertTrue((boundComponent as? CapturingEventGraphicComponent) === context.scene.stubbedEventGraphicComponent)
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
        
        XCTAssertEqual(eventDescription.contents, context.scene.stubbedEventDescriptionComponent.capturedEventDescription)
        XCTAssertTrue((boundComponent as? CapturingEventDescriptionComponent) === context.scene.stubbedEventDescriptionComponent)
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
        let viewModel = StubSuperSponsorsOnlyEventViewModel(superSponsorsOnlyWarningViewModel: superSponsorsOnlyWarningViewModel)
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
