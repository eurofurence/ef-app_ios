//
//  AuthenticationService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

protocol AuthenticationService {

    func add(observer: AuthenticationStateObserver)
    func perform(_ request: LoginArguments, completionHandler: @escaping (LoginServiceResult) -> Void)

}
