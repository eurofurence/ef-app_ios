@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import UIKit

class StubDealerDetailModuleProviding: DealerDetailModuleProviding {

    let stubInterface = UIViewController()
    private(set) var capturedModel: DealerIdentifier?
    func makeDealerDetailModule(for dealer: DealerIdentifier) -> UIViewController {
        capturedModel = dealer
        return stubInterface
    }

}
