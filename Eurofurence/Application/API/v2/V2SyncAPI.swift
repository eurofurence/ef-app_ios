//
//  V2SyncAPI.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 27/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct V2SyncAPI: SyncAPI {

    var jsonSession: JSONSession

    func fetchLatestData(completionHandler: @escaping (APISyncResponse?) -> Void) {
        let url = "https://app.eurofurence.org/api/v2/Sync"
        let request = JSONRequest(url: url, body: Data())
        jsonSession.get(request) { (_, _) in

        }
    }

}
