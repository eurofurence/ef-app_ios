import EurofurenceApplication
import EurofurenceModel
import EurofurenceModelTestDoubles
import UIKit

class StubDealerDetailComponentFactory: DealerDetailComponentFactory {

    let stubInterface = UIViewController()
    private(set) var capturedModel: DealerIdentifier?
    func makeDealerDetailComponent(for dealer: DealerIdentifier) -> UIViewController {
        capturedModel = dealer
        return stubInterface
    }

}
