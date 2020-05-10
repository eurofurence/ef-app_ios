import EurofurenceModel
import UIKit.UIViewController

public protocol MessageDetailComponentFactory {

    func makeMessageDetailComponent(for message: MessageIdentifier) -> UIViewController

}
