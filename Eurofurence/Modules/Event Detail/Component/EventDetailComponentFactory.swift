import EurofurenceModel
import UIKit.UIViewController

public protocol EventDetailComponentFactory {

    func makeEventDetailComponent(
        for event: EventIdentifier,
        delegate: EventDetailComponentDelegate
    ) -> UIViewController

}
