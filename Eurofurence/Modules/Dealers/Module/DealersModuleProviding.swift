import UIKit.UIViewController

protocol DealersModuleProviding {

    func makeDealersModule(_ delegate: DealersModuleDelegate) -> UIViewController

}
