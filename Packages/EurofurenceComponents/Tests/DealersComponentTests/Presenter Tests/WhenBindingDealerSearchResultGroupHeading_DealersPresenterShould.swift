import DealersComponent
import EurofurenceModel
import XCTest

class WhenBindingDealerSearchResultGroupHeading_DealersPresenterShould: XCTestCase {

    func testBindTheGroupHeadingOntoTheComponent() {
        let groups = [DealersGroupViewModel].random
        let randomGroup = groups.randomElement()
        let expected = randomGroup.element.title
        let searchViewModel = CapturingDealersSearchViewModel(dealerGroups: groups)
        let viewModelFactory = FakeDealersViewModelFactory(searchViewModel: searchViewModel)
        let context = DealersPresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        let component = context.makeAndBindComponentHeader(forSearchResultGroupAt: randomGroup.index)

        XCTAssertEqual(expected, component.capturedDealersGroupTitle)
    }

}
