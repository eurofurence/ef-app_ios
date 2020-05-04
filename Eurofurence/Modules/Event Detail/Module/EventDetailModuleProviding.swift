import EurofurenceModel
import UIKit.UIViewController

public protocol EventDetailModuleProviding {

    func makeEventDetailModule(for event: EventIdentifier, delegate: EventDetailModuleDelegate) -> UIViewController

}
