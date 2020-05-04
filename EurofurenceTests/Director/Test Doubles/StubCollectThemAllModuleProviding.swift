import Eurofurence
import UIKit

class StubCollectThemAllModuleProviding: CollectThemAllModuleProviding {

    let stubInterface = FakeViewController()
    func makeCollectThemAllModule() -> UIViewController {
        return stubInterface
    }

}
