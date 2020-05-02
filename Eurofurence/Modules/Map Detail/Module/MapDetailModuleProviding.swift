import EurofurenceModel
import UIKit

public protocol MapDetailModuleProviding {

    func makeMapDetailModule(
        for map: MapIdentifier,
        delegate: MapDetailModuleDelegate
    ) -> UIViewController

}
