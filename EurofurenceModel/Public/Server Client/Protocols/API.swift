//
//  API.swift
//  EurofurenceModel
//
//  Created by Thomas Sherwood on 17/02/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import Foundation

public protocol API {

    func fetchLatestData(lastSyncTime: Date?, completionHandler: @escaping (ModelCharacteristics?) -> Void)

    func fetchImage(identifier: String, completionHandler: @escaping (Data?) -> Void)

    func performLogin(request: LoginRequest, completionHandler: @escaping (LoginResponse?) -> Void)

    func loadPrivateMessages(authorizationToken: String, completionHandler: @escaping ([MessageCharacteristics]?) -> Void)

    func markMessageWithIdentifierAsRead(_ identifier: String, authorizationToken: String)

}
