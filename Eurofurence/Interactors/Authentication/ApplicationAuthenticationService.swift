//
//  ApplicationAuthenticationService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

class ApplicationAuthenticationService: AuthenticationService {

    static let shared = ApplicationAuthenticationService(app: EurofurenceApplication.shared)

    private let app: EurofurenceApplicationProtocol
    private var observers = [AuthenticationStateObserver]()

    init(app: EurofurenceApplicationProtocol) {
        self.app = app
    }

    func add(observer: AuthenticationStateObserver) {
        observers.append(observer)
    }

    func determineAuthState(completionHandler: @escaping (AuthState) -> Void) {
        app.retrieveCurrentUser { user in
            if let user = user {
                completionHandler(.loggedIn(user))
            } else {
                completionHandler(.loggedOut)
            }
        }
    }

    func perform(_ request: LoginServiceRequest, completionHandler: @escaping (LoginServiceResult) -> Void) {
        let arguments = LoginArguments(registrationNumber: request.registrationNumber,
                                       username: request.username,
                                       password: request.password)
        app.login(arguments) { (result) in
            switch result {
            case .success(let user):
                completionHandler(.success)
                self.observers.forEach { $0.userDidLogin(user) }

            case .failure:
                completionHandler(.failure)
            }
        }
    }

}
