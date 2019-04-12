import EurofurenceModel
import UIKit.UIViewController

protocol EventDetailModuleProviding {

    func makeEventDetailModule(for event: EventIdentifier) -> UIViewController

}
