//
//  AppVersionProviding.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 16/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

protocol AppVersionProviding {

    var version: String { get }

}

struct BundleAppVersionProviding: AppVersionProviding {

    static let shared = BundleAppVersionProviding()

    var version: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }

}
