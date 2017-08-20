//
//  LoginAPI.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 20/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

typealias LoginResponseHandler = (APIResponse<APILoginResponse>) -> Void

protocol LoginAPI {

    func performLogin(arguments: APILoginParameters,
                      completionHandler: @escaping LoginResponseHandler)

}
