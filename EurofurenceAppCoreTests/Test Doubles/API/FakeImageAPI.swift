//
//  FakeImageAPI.swift
//  EurofurenceAppCoreTests
//
//  Created by Thomas Sherwood on 10/10/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import Foundation

class FakeImageAPI: ImageAPI {

    private(set) var downloadedImageIdentifiers = [String]()
    func fetchImage(identifier: String, completionHandler: @escaping (Data?) -> Void) {
        downloadedImageIdentifiers.append(identifier)
        completionHandler(identifier.data(using: .utf8)!)
    }

}

extension FakeImageAPI {

    func stubbedImage(for identifier: String?) -> Data? {
        return identifier?.data(using: .utf8)
    }

}

class SlowFakeImageAPI: FakeImageAPI {

    fileprivate var pendingFetches = [() -> Void]()

    var numberOfPendingFetches: Int {
        return pendingFetches.count
    }

    override func fetchImage(identifier: String, completionHandler: @escaping (Data?) -> Void) {
        pendingFetches.append {
            super.fetchImage(identifier: identifier, completionHandler: completionHandler)
        }
    }

}

extension SlowFakeImageAPI {

    func resolvePendingFetches() {
        pendingFetches.forEach({ $0() })
        pendingFetches.removeAll()
    }

    func resolveNextFetch() {
        guard pendingFetches.count > 0 else { return }

        let next = pendingFetches.remove(at: 0)
        next()
    }

}
