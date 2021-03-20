import EurofurenceModel
import ScheduleComponent
import XCTComponentBase
import XCTest
import XCTScheduleComponent

class WhenBindingFavouriteEvent_FromSearchResult_SchedulePresenterShould: XCTestCase {

    func testTellTheSceneToShowTheFavouriteEventIndicator() {
        let searchResult = StubScheduleEventViewModel.random
        searchResult.isFavourite = true
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfSearchResult(searchResult)

        XCTAssertEqual(component.favouriteIconVisibility, .visible)
    }

    func testSupplyUnfavouriteAction() throws {
        let searchViewModel = CapturingScheduleSearchViewModel()
        let viewModelFactory = FakeScheduleViewModelFactory(searchViewModel: searchViewModel)
        let context = SchedulePresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        let searchResult = StubScheduleEventViewModel.random
        searchResult.isFavourite = true
        let results = [ScheduleEventGroupViewModel(title: .random, events: [searchResult])]
        searchViewModel.simulateSearchResultsUpdated(results)
        let indexPath = IndexPath(item: 0, section: 0)
        let commands = context.scene.searchResultsBinder?.eventActionsForComponent(at: indexPath)
        
        let action = try XCTUnwrap(commands?.command(titled: .unfavourite))
        action.run(nil)

        XCTAssertFalse(searchResult.isFavourite, "Running the action should unfavourite the event")
    }

}
