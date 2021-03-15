import EurofurenceApplication
import EurofurenceModel
import XCTest

class WhenBindingAboutTheArtComponent_DealerDetailPresenterShould: XCTestCase {

    func testBindTheArtistInformation() {
        let viewModel = DealerDetailAboutTheArtViewModel.random
        let viewModelWrapper = FakeDealerDetailAboutTheArtViewModel(aboutTheArt: viewModel)
        let viewModelFactory = FakeDealerDetailViewModelFactory(viewModel: viewModelWrapper)
        let context = DealerDetailPresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        context.bindComponent(at: 0)
        
        XCTAssertEqual(viewModel.title, context.boundAboutTheArtComponent?.capturedTitle)
        XCTAssertEqual(viewModel.aboutTheArt, context.boundAboutTheArtComponent?.capturedAboutTheArt)
        XCTAssertEqual(viewModel.artPreviewCaption, context.boundAboutTheArtComponent?.capturedArtPreviewCaption)
        XCTAssertEqual(
            viewModel.artPreviewImagePNGData,
            context.boundAboutTheArtComponent?.capturedArtPreviewImagePNGData
        )
    }

}
