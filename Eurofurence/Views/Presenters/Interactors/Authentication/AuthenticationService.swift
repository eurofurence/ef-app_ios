//
//  AuthenticationService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

protocol AuthenticationService {

    func add(observer: AuthStateObserver)
    func determineAuthState(completionHandler: @escaping (AuthState) -> Void)
    func perform(_ request: LoginServiceRequest, completionHandler: @escaping (LoginServiceResult) -> Void)

}
