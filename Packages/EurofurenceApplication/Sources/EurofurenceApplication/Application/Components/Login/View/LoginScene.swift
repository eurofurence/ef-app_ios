public protocol LoginScene: AnyObject {

    var delegate: LoginSceneDelegate? { get set }

    func setLoginTitle(_ title: String)
    func overrideRegistrationNumber(_ registrationNumber: String)
    
    func disableLoginButton()
    func enableLoginButton()

}

public protocol LoginSceneDelegate {

    func loginSceneWillAppear()
    func loginSceneDidTapCancelButton()
    func loginSceneDidTapLoginButton()
    func loginSceneDidUpdateRegistrationNumber(_ registrationNumberString: String)
    func loginSceneDidUpdateUsername(_ username: String)
    func loginSceneDidUpdatePassword(_ password: String)

}
