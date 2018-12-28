//
//  SyncAPI.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public protocol SyncAPI {

    func fetchLatestData(lastSyncTime: Date?, completionHandler: @escaping (APISyncResponse?) -> Void)

}
