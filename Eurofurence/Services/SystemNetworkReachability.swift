//
//  SwiftNetworkReachability.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 11/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import ReachabilitySwift

struct SwiftNetworkReachability: NetworkReachability {

    static let shared = SwiftNetworkReachability()
    private var reachability: Reachability

    private init() {
        guard let reachability = Reachability() else {
            fatalError("Unable to configure Reachability")
        }

        self.reachability = reachability
    }

    var wifiReachable: Bool {
        return reachability.isReachableViaWiFi
    }

}
