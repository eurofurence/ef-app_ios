import UIKit

public protocol MapsComponentFactory {

    func makeMapsModule(_ delegate: MapsComponentDelegate) -> UIViewController

}
