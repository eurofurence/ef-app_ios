//
//  SyncAPI.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol SyncAPI {

    func fetchLatestData(completionHandler: @escaping (APISyncResponse?) -> Void)

}
