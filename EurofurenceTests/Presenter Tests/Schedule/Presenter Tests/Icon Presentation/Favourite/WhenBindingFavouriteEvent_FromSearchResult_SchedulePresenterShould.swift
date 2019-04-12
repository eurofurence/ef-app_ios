@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenBindingFavouriteEvent_FromSearchResult_SchedulePresenterShould: XCTestCase {

    func testTellTheSceneToShowTheFavouriteEventIndicator() {
        let searchResult = StubScheduleEventViewModel.random
        searchResult.isFavourite = true
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfSearchResult(searchResult)

        XCTAssertEqual(component.favouriteIconVisibility, .visible)
    }

    func testSupplyUnfavouriteActionInformation() {
        let searchViewModel = CapturingScheduleSearchViewModel()
        let interactor = FakeScheduleInteractor(searchViewModel: searchViewModel)
        let context = SchedulePresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let searchResult = StubScheduleEventViewModel.random
        searchResult.isFavourite = true
        let results = [ScheduleEventGroupViewModel(title: .random, events: [searchResult])]
        searchViewModel.simulateSearchResultsUpdated(results)
        let indexPath = IndexPath(item: 0, section: 0)
        let action = context.scene.searchResultsBinder?.eventActionForComponent(at: indexPath)

        XCTAssertEqual(.unfavourite, action?.title)
    }

    func testTellViewModelToUnfavouriteEventAtIndexPathWhenInvokingAction() {
        let searchViewModel = CapturingScheduleSearchViewModel()
        let interactor = FakeScheduleInteractor(searchViewModel: searchViewModel)
        let context = SchedulePresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let searchResult = StubScheduleEventViewModel.random
        searchResult.isFavourite = true
        let results = [ScheduleEventGroupViewModel(title: .random, events: [searchResult])]
        searchViewModel.simulateSearchResultsUpdated(results)
        let indexPath = IndexPath(item: 0, section: 0)
        let action = context.scene.searchResultsBinder?.eventActionForComponent(at: indexPath)
        action?.run()

        XCTAssertEqual(indexPath, searchViewModel.indexPathForUnfavouritedEvent)
    }

}
