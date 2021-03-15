import EurofurenceApplication
import EurofurenceModel
import EurofurenceModelTestDoubles
import UIKit.UIViewController

class StubMessageDetailComponentFactory: MessageDetailComponentFactory {

    let stubInterface = UIViewController()
    private(set) var capturedMessage: MessageIdentifier?
    func makeMessageDetailComponent(for message: MessageIdentifier) -> UIViewController {
        capturedMessage = message
        return stubInterface
    }

}
