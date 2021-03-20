import EurofurenceModel
import ScheduleComponent
import XCTest

class WhenSceneChangesSearchScopeToFavouriteEvents_SchedulePresenterShould: XCTestCase {

    func testTellTheSearchViewModelToFilterToFavourites() {
        let searchViewModel = CapturingScheduleSearchViewModel()
        let viewModelFactory = FakeScheduleViewModelFactory(searchViewModel: searchViewModel)
        let context = SchedulePresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        context.scene.delegate?.scheduleSceneDidChangeSearchScopeToFavouriteEvents()

        XCTAssertTrue(searchViewModel.didFilterToFavourites)
    }

    func testTellTheSearchResultsToAppear() {
        let context = SchedulePresenterTestBuilder().build()
        context.simulateSceneDidLoad()
        context.scene.delegate?.scheduleSceneDidChangeSearchScopeToFavouriteEvents()

        XCTAssertTrue(context.scene.didShowSearchResults)
    }

    func testTellTheSearchResultsToAppearWhenQueryChangesToEmptyString() {
        let context = SchedulePresenterTestBuilder().build()
        context.simulateSceneDidLoad()
        context.scene.delegate?.scheduleSceneDidChangeSearchScopeToFavouriteEvents()
        context.scene.delegate?.scheduleSceneDidUpdateSearchQuery("")

        XCTAssertEqual(2, context.scene.didShowSearchResultsCount)
    }

}
