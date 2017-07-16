//
//  BundleAppVersionProviding.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 16/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

struct BundleAppVersionProviding: AppVersionProviding {

    var version: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }

}
