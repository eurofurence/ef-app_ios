//
//  LoginTask.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 20/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

protocol LoginTaskDelegate {

    func loginTask(_ task: LoginTask, didProduce credential: Credential)
    func loginTaskDidFail(_ task: LoginTask)

}

struct LoginTask {

    let delegate: LoginTaskDelegate
    let arguments: LoginArguments
    let loginAPI: LoginAPI

    func start() {
        let request = LoginRequest(regNo: arguments.registrationNumber,
                                   username: arguments.username,
                                   password: arguments.password,
                                   completionHandler: handleLoginResult)
        loginAPI.performLogin(request: request)
    }

    private func handleLoginResult(_ result: APIResponse<APILoginResponse>) {
        switch result {
        case .success(let response):
            let credential = Credential(username: arguments.username,
                                             registrationNumber: arguments.registrationNumber,
                                             authenticationToken: response.token,
                                             tokenExpiryDate: response.tokenValidUntil)
            delegate.loginTask(self, didProduce: credential)

        case .failure:
            delegate.loginTaskDidFail(self)
        }
    }

}
