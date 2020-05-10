@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenBindingAboutTheArtComponent_DealerDetailPresenterShould: XCTestCase {

    var context: DealerDetailPresenterTestBuilder.Context!
    var aboutTheArtViewModel: DealerDetailAboutTheArtViewModel!

    override func setUp() {
        super.setUp()

        aboutTheArtViewModel = DealerDetailAboutTheArtViewModel.random
        let viewModel = FakeDealerDetailAboutTheArtViewModel(aboutTheArt: aboutTheArtViewModel)
        let viewModelFactory = FakeDealerDetailViewModelFactory(viewModel: viewModel)
        context = DealerDetailPresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        context.bindComponent(at: 0)
    }

    func testBindTheTitleOntoTheComponent() {
        XCTAssertEqual(aboutTheArtViewModel.title, context.boundAboutTheArtComponent?.capturedTitle)
    }

    func testBindTheArtDescriptionOntoTheComponent() {
        XCTAssertEqual(aboutTheArtViewModel.aboutTheArt, context.boundAboutTheArtComponent?.capturedAboutTheArt)
    }

    func testBindTheArtPreviewImagePNGDataOntoTheComponent() {
        XCTAssertEqual(aboutTheArtViewModel.artPreviewImagePNGData, context.boundAboutTheArtComponent?.capturedArtPreviewImagePNGData)
    }

    func testBindTheArtPreviewCaptionOntoTheComponent() {
        XCTAssertEqual(aboutTheArtViewModel.artPreviewCaption, context.boundAboutTheArtComponent?.capturedArtPreviewCaption)
    }

}
