import ContentController
import UIKit

struct StubPrincipalContentModuleProviding: PrincipalContentModuleFactory {
    
    let stubInterface = UIViewController()
    func makePrincipalContentModule() -> UIViewController {
        stubInterface
    }
    
}
