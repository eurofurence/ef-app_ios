import Eurofurence
import UIKit

struct StubPrincipalContentModuleProviding: PrincipalContentModuleProviding {
    
    let stubInterface = UIViewController()
    func makePrincipalContentModule() -> UIViewController {
        stubInterface
    }
    
}
