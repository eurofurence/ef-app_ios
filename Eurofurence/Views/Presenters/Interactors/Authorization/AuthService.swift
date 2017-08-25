//
//  AuthService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

enum AuthState {
    case loggedIn(User)
    case loggedOut
}

protocol AuthService {

    func add(observer: AuthStateObserver)
    func determineAuthState(completionHandler: @escaping (AuthState) -> Void)

}

protocol AuthStateObserver {

    func userDidLogin(_ user: User)
    func userDidLogout()

}
