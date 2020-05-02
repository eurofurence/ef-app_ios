import UIKit.UIViewController

public protocol LoginModuleProviding {

    func makeLoginModule(_ delegate: LoginModuleDelegate) -> UIViewController

}

public protocol LoginModuleDelegate {

    func loginModuleDidCancelLogin()
    func loginModuleDidLoginSuccessfully()

}
