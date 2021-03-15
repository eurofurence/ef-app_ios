import EurofurenceApplication
import EurofurenceModel
import XCTest

class SchedulePresenterLeaveFeedbackCommandTests: XCTestCase {

    func testLeavingFeedback() throws {
        let eventViewModel = StubScheduleEventViewModel.random
        eventViewModel.isAcceptingFeedback = true
        let eventGroupViewModel = ScheduleEventGroupViewModel(title: .random, events: [eventViewModel])
        let viewModel = CapturingScheduleViewModel(days: .random, events: [eventGroupViewModel], currentDay: 0)
        let viewModelFactory = FakeScheduleViewModelFactory(viewModel: viewModel)
        let context = SchedulePresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        let searchResult = StubScheduleEventViewModel.random
        searchResult.isFavourite = false
        let indexPath = IndexPath(item: 0, section: 0)
        let eventIdentifier = EventIdentifier.random
        viewModel.stub(eventIdentifier, at: indexPath)
        let commands = context.scene.binder?.eventActionsForComponent(at: indexPath)
        
        let action = try XCTUnwrap(commands?.command(titled: .leaveFeedback))

        XCTAssertEqual("square.and.pencil", action.sfSymbol)
        
        action.run(nil)
        
        XCTAssertEqual(eventIdentifier, context.delegate.capturedEventIdentifierForFeedback)
    }
    
    func testDoesNotIncludeFeedbackCommandWhenEventIsNotAcceptingIt() {
        let eventViewModel = StubScheduleEventViewModel.random
        eventViewModel.isAcceptingFeedback = false
        let eventGroupViewModel = ScheduleEventGroupViewModel(title: .random, events: [eventViewModel])
        let viewModel = CapturingScheduleViewModel(days: .random, events: [eventGroupViewModel], currentDay: 0)
        let viewModelFactory = FakeScheduleViewModelFactory(viewModel: viewModel)
        let context = SchedulePresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        let searchResult = StubScheduleEventViewModel.random
        searchResult.isFavourite = false
        let indexPath = IndexPath(item: 0, section: 0)
        let eventIdentifier = EventIdentifier.random
        viewModel.stub(eventIdentifier, at: indexPath)
        let commands = context.scene.binder?.eventActionsForComponent(at: indexPath)
        
        let action = commands?.command(titled: .leaveFeedback)
        
        XCTAssertNil(action, "Leave feedback command should not be available if the event isn't accepting any")
    }

}
