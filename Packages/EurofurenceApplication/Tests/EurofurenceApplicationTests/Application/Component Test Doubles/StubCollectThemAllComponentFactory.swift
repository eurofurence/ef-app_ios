import EurofurenceApplication
import UIKit

class StubCollectThemAllComponentFactory: CollectThemAllComponentFactory {

    let stubInterface = FakeViewController()
    func makeCollectThemAllComponent() -> UIViewController {
        return stubInterface
    }

}
