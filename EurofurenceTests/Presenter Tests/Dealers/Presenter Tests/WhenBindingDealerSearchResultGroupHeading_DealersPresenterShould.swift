@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenBindingDealerSearchResultGroupHeading_DealersPresenterShould: XCTestCase {

    func testBindTheGroupHeadingOntoTheComponent() {
        let groups = [DealersGroupViewModel].random
        let randomGroup = groups.randomElement()
        let expected = randomGroup.element.title
        let searchViewModel = CapturingDealersSearchViewModel(dealerGroups: groups)
        let interactor = FakeDealersInteractor(searchViewModel: searchViewModel)
        let context = DealersPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let component = context.makeAndBindComponentHeader(forSearchResultGroupAt: randomGroup.index)

        XCTAssertEqual(expected, component.capturedDealersGroupTitle)
    }

}
