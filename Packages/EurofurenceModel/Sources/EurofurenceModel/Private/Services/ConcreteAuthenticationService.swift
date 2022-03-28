import Foundation

class ConcreteAuthenticationService: AuthenticationService {

    private let eventBus: EventBus
    private let clock: Clock
    private let credentialRepository: CredentialRepository
    private let api: API
    private let remoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration?
    private var userAuthenticationToken: String?
    private var registeredDeviceToken: Data?
    private var loggedInUser: User?
    private var observers = [AuthenticationStateObserver]()
    private var subscription: Any?
    
    private struct StoreNotificationTokenWhenChanged: EventConsumer {
        
        private unowned let controller: ConcreteAuthenticationService
        
        init(controller: ConcreteAuthenticationService) {
            self.controller = controller
        }
        
        func consume(event: DomainEvent.RemoteNotificationTokenAvailable) {
            controller.remoteNotificationTokenDidChange(event)
        }
        
    }

    init(
        eventBus: EventBus,
        clock: Clock,
        credentialRepository: CredentialRepository,
        remoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration?,
        api: API
    ) {
        self.eventBus = eventBus
        self.clock = clock
        self.credentialRepository = credentialRepository
        self.api = api
        self.remoteNotificationsTokenRegistration = remoteNotificationsTokenRegistration

        loadPersistedCredential()
        subscription = eventBus.subscribe(consumer: StoreNotificationTokenWhenChanged(controller: self))
    }

    func login(_ args: LoginArguments, completionHandler: @escaping (LoginResult) -> Void) {
        if let user = loggedInUser {
            completionHandler(.success(user))
            return
        }

        let request = LoginRequest(regNo: args.registrationNumber, username: args.username, password: args.password)
        api.performLogin(request: request) { (response) in
            if let response = response {
                self.handleLoginSuccess(args, response: response, completionHandler: completionHandler)
            } else {
                completionHandler(.failure)
            }
        }
    }
    
    func logout(completionHandler: @escaping (LogoutResult) -> Void) {
        remoteNotificationsTokenRegistration?.registerRemoteNotificationsDeviceToken(
            registeredDeviceToken,
            userAuthenticationToken: nil,
            completionHandler: { error in
                if error != nil {
                    completionHandler(.failure)
                } else {
                    self.credentialRepository.deletePersistedToken()
                    self.loggedInUser = nil
                    self.userAuthenticationToken = nil
                    self.observers.forEach({ $0.userUnauthenticated() })
                    self.eventBus.post(DomainEvent.LoggedOut())
                    completionHandler(.success)
                }
            }
        )
    }

    func add(_ observer: AuthenticationStateObserver) {
        observers.append(observer)

        if let user = loggedInUser {
            observer.userAuthenticated(user)
        } else {
            observer.userUnauthenticated()
        }
    }

    // MARK: Private

    private func loadPersistedCredential() {
        let currentDate = clock.currentDate
        if let credential = credentialRepository.persistedCredential, credential.isValid(currentDate: currentDate) {
            updateCurrentUser(from: credential)
        }
    }

    private func remoteNotificationTokenDidChange(_ event: DomainEvent.RemoteNotificationTokenAvailable) {
        registeredDeviceToken = event.deviceToken
    }
    
    private func handleLoginSuccess(
        _ args: LoginArguments,
        response: LoginResponse,
        completionHandler: @escaping (LoginResult) -> Void
    ) {
        let credential = Credential(
            username: args.username,
            registrationNumber: args.registrationNumber,
            authenticationToken: response.token,
            tokenExpiryDate: response.tokenValidUntil
        )
        
        credentialRepository.store(credential)
        updateCurrentUser(from: credential)
        
        if let loggedInUser = loggedInUser {
            completionHandler(.success(loggedInUser))
        }
    }

    private func updateCurrentUser(from credential: Credential) {
        userAuthenticationToken = credential.authenticationToken
        let user = User(registrationNumber: credential.registrationNumber, username: credential.username)
        loggedInUser = user
        eventBus.post(DomainEvent.LoggedIn(user: user, authenticationToken: credential.authenticationToken))
        observers.forEach({ $0.userAuthenticated(user) })
    }

}
