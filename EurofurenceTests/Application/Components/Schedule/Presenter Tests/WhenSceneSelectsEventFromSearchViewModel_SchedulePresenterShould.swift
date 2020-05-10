@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenSceneSelectsEventFromSearchViewModel_SchedulePresenterShould: XCTestCase {

    func testTellModuleEventWithResolvedIdentifierSelected() {
        let searchViewModel = CapturingScheduleSearchViewModel()
        let viewModelFactory = FakeScheduleViewModelFactory(searchViewModel: searchViewModel)
        let context = SchedulePresenterTestBuilder().with(viewModelFactory).build()
        let results = [ScheduleEventGroupViewModel].random
        context.simulateSceneDidLoad()
        searchViewModel.simulateSearchResultsUpdated(results)
        let randomGroup = results.randomElement()
        let randomEvent = randomGroup.element.events.randomElement()
        let indexPath = IndexPath(item: randomEvent.index, section: randomGroup.index)
        let selectedIdentifier = EventIdentifier.random
        searchViewModel.stub(selectedIdentifier, at: indexPath)
        context.simulateSceneDidSelectSearchResult(at: indexPath)

        XCTAssertEqual(selectedIdentifier, context.delegate.capturedEventIdentifier)
    }

    func testTellTheSceneToDeselectTheSelectedSearchResult() {
        let context = SchedulePresenterTestBuilder().build()
        context.simulateSceneDidLoad()
        let indexPath = IndexPath.random
        context.simulateSceneDidSelectSearchResult(at: indexPath)

        XCTAssertEqual(indexPath, context.scene.deselectedSearchResultIndexPath)
    }

}
