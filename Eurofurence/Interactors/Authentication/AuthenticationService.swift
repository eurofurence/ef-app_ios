//
//  AuthenticationService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

protocol AuthenticationService {

    func add(_ observer: AuthenticationStateObserver)
    func login(_ arguments: LoginArguments, completionHandler: @escaping (LoginResult) -> Void)

}
