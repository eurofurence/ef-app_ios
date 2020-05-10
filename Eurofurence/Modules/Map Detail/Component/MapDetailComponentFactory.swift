import EurofurenceModel
import UIKit

public protocol MapDetailComponentFactory {

    func makeMapDetailComponent(
        for map: MapIdentifier,
        delegate: MapDetailComponentDelegate
    ) -> UIViewController

}
