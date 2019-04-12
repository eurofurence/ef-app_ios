import EurofurenceModel
import UIKit

protocol MapDetailModuleProviding {

    func makeMapDetailModule(for map: MapIdentifier, delegate: MapDetailModuleDelegate) -> UIViewController

}
