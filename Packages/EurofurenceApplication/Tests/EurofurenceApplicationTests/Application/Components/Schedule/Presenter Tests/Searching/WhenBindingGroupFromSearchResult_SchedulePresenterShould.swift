import EurofurenceApplication
import EurofurenceModel
import XCTest

class WhenBindingGroupFromSearchResult_SchedulePresenterShould: XCTestCase {

    func testBindTheGroupTitleOntoTheHeader() {
        let searchViewModel = CapturingScheduleSearchViewModel()
        let viewModelFactory = FakeScheduleViewModelFactory(searchViewModel: searchViewModel)
        let context = SchedulePresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        let results = [ScheduleEventGroupViewModel].random
        searchViewModel.simulateSearchResultsUpdated(results)
        let randomGroup = results.randomElement()
        let header = CapturingScheduleEventGroupHeader()
        context.bindSearchResultHeading(header, forSearchResultGroupAt: randomGroup.index)

        XCTAssertEqual(randomGroup.element.title, header.capturedTitle)
    }

}
