import UIKit.UIViewController

protocol DealersComponentFactory {

    func makeDealersComponent(_ delegate: DealersComponentDelegate) -> UIViewController

}
