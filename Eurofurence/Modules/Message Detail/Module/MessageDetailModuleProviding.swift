import EurofurenceModel
import UIKit.UIViewController

protocol MessageDetailModuleProviding {

    func makeMessageDetailModule(for message: MessageIdentifier) -> UIViewController

}
