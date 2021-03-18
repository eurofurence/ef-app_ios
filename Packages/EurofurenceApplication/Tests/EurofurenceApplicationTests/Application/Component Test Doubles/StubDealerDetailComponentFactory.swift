import DealerComponent
import EurofurenceApplication
import EurofurenceModel
import UIKit
import XCTEurofurenceModel

class StubDealerDetailComponentFactory: DealerDetailComponentFactory {

    let stubInterface = UIViewController()
    private(set) var capturedModel: DealerIdentifier?
    func makeDealerDetailComponent(for dealer: DealerIdentifier) -> UIViewController {
        capturedModel = dealer
        return stubInterface
    }

}
