@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import UIKit.UIViewController

class StubMessageDetailModuleProviding: MessageDetailModuleProviding {

    let stubInterface = UIViewController()
    private(set) var capturedMessage: Message?
    func makeMessageDetailModule(message: Message) -> UIViewController {
        capturedMessage = message
        return stubInterface
    }

}
