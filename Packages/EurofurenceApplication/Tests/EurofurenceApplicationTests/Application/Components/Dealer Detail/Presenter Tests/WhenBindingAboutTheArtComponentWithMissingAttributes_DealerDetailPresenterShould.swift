import EurofurenceApplication
import EurofurenceModel
import XCTest

class WhenBindingAboutTheArtComponentWithMissingAttributes_DealerDetailPresenterShould: XCTestCase {

    func testHideTheAboutTheArtInformation() {
        let aboutTheArtViewModel = DealerDetailAboutTheArtViewModel.random
        let viewModel = FakeDealerDetailAboutTheArtViewModel(aboutTheArt: aboutTheArtViewModel)
        let viewModelFactory = FakeDealerDetailViewModelFactory(viewModel: viewModel)
        let context = DealerDetailPresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        context.bindComponent(at: 0)
        
        XCTAssertEqual(true, context.boundAboutTheArtComponent?.didHideAboutTheArtDescription)
        XCTAssertEqual(true, context.boundAboutTheArtComponent?.didHideArtPreview)
        XCTAssertEqual(true, context.boundAboutTheArtComponent?.didHideArtPreviewCaption)
    }

}
