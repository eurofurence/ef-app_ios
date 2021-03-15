import EurofurenceApplication
import XCTest

class WhenTappingShareButton_DealerDetailPresenterShould: XCTestCase {

    func testPerformTheShareCommand() {
        let viewModel = FakeDealerDetailViewModel(numberOfComponents: .random)
        let viewModelFactory = FakeDealerDetailViewModelFactory(viewModel: viewModel)
        let context = DealerDetailPresenterTestBuilder().with(viewModelFactory).build()
        context.simulateSceneDidLoad()
        
        let sender = self
        context.scene.simulateShareButtonTapped(self)
        
        XCTAssertTrue(sender === (viewModel.shareCommandSender as AnyObject))
    }

}
