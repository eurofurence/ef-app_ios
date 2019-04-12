import UIKit.UIViewController

protocol LoginModuleProviding {

    func makeLoginModule(_ delegate: LoginModuleDelegate) -> UIViewController

}

protocol LoginModuleDelegate {

    func loginModuleDidCancelLogin()
    func loginModuleDidLoginSuccessfully()

}
