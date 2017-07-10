//
//  StubReachability.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 10/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence

struct StubNetworkReachability: NetworkReachability {

    var wifiReachable: Bool = false

}
