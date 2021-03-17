import UIKit.UIViewController

public protocol DealersComponentFactory {

    func makeDealersComponent(_ delegate: DealersComponentDelegate) -> UIViewController

}
