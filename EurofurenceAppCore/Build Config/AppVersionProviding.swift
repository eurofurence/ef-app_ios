//
//  AppVersionProviding.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 16/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

public protocol AppVersionProviding {

    var version: String { get }

}

public struct BundleAppVersionProviding: AppVersionProviding {

    public static let shared = BundleAppVersionProviding()

    public var version: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }

}
