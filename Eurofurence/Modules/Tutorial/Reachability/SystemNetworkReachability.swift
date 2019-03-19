//
//  SwiftNetworkReachability.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 11/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import SystemConfiguration

public struct SystemConfigurationNetworkReachability: NetworkReachability {

    public init() {
        
    }

    public var wifiReachable: Bool {
        return isWifiReachable(with: resolveCurrentReachabilityFlags())
    }
    
    public var cellularReachable: Bool {
        return true
    }
    
    private func resolveCurrentReachabilityFlags() -> SCNetworkReachabilityFlags {
        var zeroAddress = sockaddr()
        zeroAddress.sa_len = UInt8(MemoryLayout<sockaddr>.size)
        zeroAddress.sa_family = sa_family_t(AF_INET)
        
        var flags: SCNetworkReachabilityFlags = []
        if let systemReachability = SCNetworkReachabilityCreateWithAddress(nil, &zeroAddress) {
            SCNetworkReachabilityGetFlags(systemReachability, &flags)
        }
        
        return flags
    }
    
    private func isWifiReachable(with flags: SCNetworkReachabilityFlags) -> Bool {
        return flags.contains(.reachable) && flags.contains(.isWWAN) == false
    }

}
