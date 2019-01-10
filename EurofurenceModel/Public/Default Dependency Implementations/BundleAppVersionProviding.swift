//
//  BundleAppVersionProviding.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 28/12/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public struct BundleAppVersionProviding: AppVersionProviding {

    public static let shared = BundleAppVersionProviding()

    public var version: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }

}
