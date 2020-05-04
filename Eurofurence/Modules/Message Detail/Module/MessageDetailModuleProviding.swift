import EurofurenceModel
import UIKit.UIViewController

public protocol MessageDetailModuleProviding {

    func makeMessageDetailModule(for message: MessageIdentifier) -> UIViewController

}
