//
//  FakeAPI.swift
//  EurofurenceAppCoreTests
//
//  Created by Thomas Sherwood on 10/10/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation

class FakeAPI: API {

    private(set) var capturedLoginRequest: LoginRequest?
    private var handler: ((LoginResponse?) -> Void)?
    func performLogin(request: LoginRequest, completionHandler: @escaping (LoginResponse?) -> Void) {
        capturedLoginRequest = request
        handler = completionHandler
    }

    func loadPrivateMessages(authorizationToken: String, completionHandler: @escaping ([MessageCharacteristics]?) -> Void) {

    }

    func markMessageWithIdentifierAsRead(_ identifier: String, authorizationToken: String) {

    }

    func fetchLatestData(lastSyncTime: Date?, completionHandler: @escaping (ModelCharacteristics?) -> Void) {

    }

    private(set) var downloadedImageIdentifiers = [String]()
    func fetchImage(identifier: String, completionHandler: @escaping (Data?) -> Void) {
        downloadedImageIdentifiers.append(identifier)
        completionHandler(identifier.data(using: .utf8)!)
    }

}

extension FakeAPI {

    func stubbedImage(for identifier: String?) -> Data? {
        return identifier?.data(using: .utf8)
    }

    func simulateResponse(_ response: LoginResponse) {
        handler?(response)
    }

    func simulateFailure() {
        handler?(nil)
    }

}

class SlowFakeImageAPI: FakeAPI {

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
