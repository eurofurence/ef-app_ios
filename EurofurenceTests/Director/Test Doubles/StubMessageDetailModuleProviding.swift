@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import UIKit.UIViewController

class StubMessageDetailModuleProviding: MessageDetailModuleProviding {

    let stubInterface = UIViewController()
    private(set) var capturedMessage: MessageIdentifier?
    func makeMessageDetailModule(for message: MessageIdentifier) -> UIViewController {
        capturedMessage = message
        return stubInterface
    }

}
