//
//  EurofurenceAuthService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

class EurofurenceAuthService: AuthService {

    static var shared = EurofurenceAuthService(app: EurofurenceApplication.shared)

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

}
