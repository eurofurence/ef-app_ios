//
//  LoginTask.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 20/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

protocol LoginTaskDelegate {

    func loginTask(_ task: LoginTask, didProduce loginCredential: LoginCredential)
    func loginTaskDidFail(_ task: LoginTask)

}

struct LoginTask {

    let delegate: LoginTaskDelegate
    let arguments: LoginArguments
    let loginAPI: LoginAPI

    func start() {
        loginAPI.performLogin(arguments: makeAPILoginParameters(from: arguments),
                              completionHandler: handleLoginResult)
    }

    private func makeAPILoginParameters(from args: LoginArguments) -> APILoginParameters {
        return APILoginParameters(regNo: args.registrationNumber, username: args.username, password: args.password)
    }

    private func handleLoginResult(_ result: APIResponse<APILoginResponse>) {
        switch result {
        case .success(let response):
            let credential = LoginCredential(username: response.username,
                                             registrationNumber: arguments.registrationNumber,
                                             authenticationToken: response.token,
                                             tokenExpiryDate: response.tokenValidUntil)
            delegate.loginTask(self, didProduce: credential)

        case .failure:
            delegate.loginTaskDidFail(self)
        }
    }

}
