import EurofurenceApplication
import UIKit

struct StubPrincipalContentModuleProviding: PrincipalContentModuleFactory {
    
    let stubInterface = UIViewController()
    func makePrincipalContentModule() -> UIViewController {
        stubInterface
    }
    
}
