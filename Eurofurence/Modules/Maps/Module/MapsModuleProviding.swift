import UIKit

public protocol MapsModuleProviding {

    func makeMapsModule(_ delegate: MapsModuleDelegate) -> UIViewController

}
