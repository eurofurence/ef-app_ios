import EurofurenceModel
import UIKit.UIViewController

protocol MessageDetailModuleProviding {

    func makeMessageDetailModule(message: Message) -> UIViewController

}
