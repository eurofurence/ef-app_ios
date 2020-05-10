@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenBindingAboutTheArtistComponent_DealerDetailPresenterShould: XCTestCase {

    func testBindTheArtistInformation() {
        let aboutTheArtistViewModel = DealerDetailAboutTheArtistViewModel.random
        let viewModel = FakeDealerDetailAboutTheArtistViewModel(aboutTheArtist: aboutTheArtistViewModel)
        let viewModelFactory = FakeDealerDetailViewModelFactory(viewModel: viewModel)
        let context = DealerDetailPresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        context.bindComponent(at: 0)

        XCTAssertEqual(aboutTheArtistViewModel.artistDescription, context.boundAboutTheArtistComponent?.capturedArtistDescription)
        XCTAssertEqual(aboutTheArtistViewModel.title, context.boundAboutTheArtistComponent?.capturedTitle)
    }

}
