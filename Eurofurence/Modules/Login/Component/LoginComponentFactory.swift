import UIKit.UIViewController

public protocol LoginComponentFactory {

    func makeLoginModule(_ delegate: LoginComponentDelegate) -> UIViewController

}

public protocol LoginComponentDelegate {

    func loginModuleDidCancelLogin()
    func loginModuleDidLoginSuccessfully()

}
