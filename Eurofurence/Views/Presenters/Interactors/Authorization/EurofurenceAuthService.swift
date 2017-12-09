//
//  EurofurenceAuthService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

class EurofurenceAuthService: AuthenticationService {

    static let shared = EurofurenceAuthService(app: EurofurenceApplication.shared)

    private let app: EurofurenceApplicationProtocol

    init(app: EurofurenceApplicationProtocol) {
        self.app = app
    }

    func add(observer: AuthStateObserver) {

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
            case .success(_):
                completionHandler(.success)

            case .failure:
                completionHandler(.failure)
            }
        }
    }

}
