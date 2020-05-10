import Eurofurence
import EurofurenceModel
import XCTest

class WhenBindingAboutTheArtComponent_DealerDetailPresenterShould: XCTestCase {

    func testBindTheArtistInformation() {
        let aboutTheArtViewModel = DealerDetailAboutTheArtViewModel.random
        let viewModel = FakeDealerDetailAboutTheArtViewModel(aboutTheArt: aboutTheArtViewModel)
        let viewModelFactory = FakeDealerDetailViewModelFactory(viewModel: viewModel)
        let context = DealerDetailPresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        context.bindComponent(at: 0)
        
        XCTAssertEqual(aboutTheArtViewModel.title, context.boundAboutTheArtComponent?.capturedTitle)
        XCTAssertEqual(aboutTheArtViewModel.aboutTheArt, context.boundAboutTheArtComponent?.capturedAboutTheArt)
        XCTAssertEqual(aboutTheArtViewModel.artPreviewImagePNGData, context.boundAboutTheArtComponent?.capturedArtPreviewImagePNGData)
        XCTAssertEqual(aboutTheArtViewModel.artPreviewCaption, context.boundAboutTheArtComponent?.capturedArtPreviewCaption)
    }

}
