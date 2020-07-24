public protocol AuthenticationService {

    func add(_ observer: AuthenticationStateObserver)
    func login(_ arguments: LoginArguments, completionHandler: @escaping (LoginResult) -> Void)
    func logout(completionHandler: @escaping (LogoutResult) -> Void)

}

public enum LoginResult {
    case success(User)
    case failure
}

public protocol AuthenticationStateObserver {

    func userAuthenticated(_ user: User)
    func userDidLogout()
    func userDidFailToLogout()

}
