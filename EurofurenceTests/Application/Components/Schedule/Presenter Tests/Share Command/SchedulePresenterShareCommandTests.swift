import Eurofurence
import EurofurenceModel
import XCTest

class SchedulePresenterShareCommandTests: XCTestCase {

    func testShareCommand() throws {
        let eventViewModel = StubScheduleEventViewModel.random
        let eventGroupViewModel = ScheduleEventGroupViewModel(title: .random, events: [eventViewModel])
        let viewModel = CapturingScheduleViewModel(days: .random, events: [eventGroupViewModel], currentDay: 0)
        let viewModelFactory = FakeScheduleViewModelFactory(viewModel: viewModel)
        let context = SchedulePresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        let searchResult = StubScheduleEventViewModel.random
        searchResult.isFavourite = false
        let indexPath = IndexPath(item: 0, section: 0)
        let commands = context.scene.binder?.eventActionsForComponent(at: indexPath)
        
        let action = try XCTUnwrap(commands?.command(titled: .share))

        XCTAssertEqual("square.and.arrow.up", action.sfSymbol)
        
        let sender = "Cell"
        action.run(sender)
        
        XCTAssertEqual(sender, eventViewModel.sharedSender as? String)
    }

}
