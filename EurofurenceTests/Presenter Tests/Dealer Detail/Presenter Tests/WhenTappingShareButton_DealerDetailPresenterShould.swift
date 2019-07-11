@testable import Eurofurence
import XCTest

class WhenTappingShareButton_DealerDetailPresenterShould: XCTestCase {

    func testPerformTheShareCommand() {
        let viewModel = FakeDealerDetailViewModel(numberOfComponents: .random)
        let interactor = FakeDealerDetailInteractor(viewModel: viewModel)
        let context = DealerDetailPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        
        let sender = self
        context.scene.simulateShareButtonTapped(self)
        
        XCTAssertTrue(sender === (viewModel.shareCommandSender as AnyObject))
    }

}
