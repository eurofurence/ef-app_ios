//
//  NetworkReachabilityTestDoubles.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 10/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Eurofurence

struct WiFiNetwork: NetworkReachability {

    var wifiReachable: Bool {
        return true
    }

}

struct CellularNetwork: NetworkReachability {

    var wifiReachable: Bool {
        return false
    }

}
