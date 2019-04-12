@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenBindingAboutTheArtistComponent_DealerDetailPresenterShould: XCTestCase {

    func testBindTheArtistDescriptionOntoTheComponent() {
        let aboutTheArtistViewModel = DealerDetailAboutTheArtistViewModel.random
        let viewModel = FakeDealerDetailAboutTheArtistViewModel(aboutTheArtist: aboutTheArtistViewModel)
        let interactor = FakeDealerDetailInteractor(viewModel: viewModel)
        let context = DealerDetailPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        context.bindComponent(at: 0)

        XCTAssertEqual(aboutTheArtistViewModel.artistDescription, context.boundAboutTheArtistComponent?.capturedArtistDescription)
    }

    func testBindTheTitleOntoTheComponent() {
        let aboutTheArtistViewModel = DealerDetailAboutTheArtistViewModel.random
        let viewModel = FakeDealerDetailAboutTheArtistViewModel(aboutTheArtist: aboutTheArtistViewModel)
        let interactor = FakeDealerDetailInteractor(viewModel: viewModel)
        let context = DealerDetailPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        context.bindComponent(at: 0)

        XCTAssertEqual(aboutTheArtistViewModel.title, context.boundAboutTheArtistComponent?.capturedTitle)
    }

}
