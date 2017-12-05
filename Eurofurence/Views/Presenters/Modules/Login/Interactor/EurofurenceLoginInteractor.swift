//
//  EurofurenceLoginInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 04/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

struct EurofurenceLoginInteractor: LoginService {

    var app: EurofurenceApplicationProtocol

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
