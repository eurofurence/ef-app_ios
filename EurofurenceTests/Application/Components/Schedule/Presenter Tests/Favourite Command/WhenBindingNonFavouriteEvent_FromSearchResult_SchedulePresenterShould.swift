import Eurofurence
import EurofurenceModel
import XCTest

class WhenBindingNonFavouriteEvent_FromSearchResult_SchedulePresenterShould: XCTestCase {

    func testPrepareTheComponentToShowFavouriteEventAction() throws {
        let searchViewModel = CapturingScheduleSearchViewModel()
        let viewModelFactory = FakeScheduleViewModelFactory(searchViewModel: searchViewModel)
        let context = SchedulePresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        let searchResult = StubScheduleEventViewModel.random
        searchResult.isFavourite = false
        let results = [ScheduleEventGroupViewModel(title: .random, events: [searchResult])]
        searchViewModel.simulateSearchResultsUpdated(results)
        let indexPath = IndexPath(item: 0, section: 0)
        let component = CapturingScheduleEventComponent()
        context.bindSearchResultComponent(component, forSearchResultAt: indexPath)
        let commands = context.scene.searchResultsBinder?.eventActionsForComponent(at: indexPath)
        
        let action = try XCTUnwrap(commands?.command(titled: .favourite))
        
        XCTAssertEqual(component.favouriteIconVisibility, .hidden)
        
        action.run(nil)

        XCTAssertTrue(searchResult.isFavourite, "Running the action should favourite the event")
    }

}
