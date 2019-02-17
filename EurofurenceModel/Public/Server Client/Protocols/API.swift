//
//  API.swift
//  EurofurenceModel
//
//  Created by Thomas Sherwood on 17/02/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import Foundation

public protocol API: LoginAPI, PrivateMessagesAPI, SyncAPI {

    func fetchImage(identifier: String, completionHandler: @escaping (Data?) -> Void)

}
