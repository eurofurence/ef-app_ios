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
    private var loginHandler: ((LoginResponse?) -> Void)?
    func performLogin(request: LoginRequest, completionHandler: @escaping (LoginResponse?) -> Void) {
        capturedLoginRequest = request
        loginHandler = completionHandler
    }

    private(set) var wasToldToLoadPrivateMessages = false
    private(set) var capturedAuthToken: String?
    private var messagesHandler: (([MessageEntity]?) -> Void)?
    func loadPrivateMessages(authorizationToken: String,
                             completionHandler: @escaping ([MessageEntity]?) -> Void) {
        wasToldToLoadPrivateMessages = true
        capturedAuthToken = authorizationToken
        self.messagesHandler = completionHandler
    }

    private(set) var messageIdentifierMarkedAsRead: String?
    private(set) var capturedAuthTokenForMarkingMessageAsRead: String?
    func markMessageWithIdentifierAsRead(_ identifier: String, authorizationToken: String) {
        messageIdentifierMarkedAsRead = identifier
        capturedAuthTokenForMarkingMessageAsRead = authorizationToken
    }

    fileprivate var completionHandler: ((ModelCharacteristics?) -> Void)?
    private(set) var capturedLastSyncTime: Date?
    private(set) var didBeginSync = false
    func fetchLatestData(lastSyncTime: Date?, completionHandler: @escaping (ModelCharacteristics?) -> Void) {
        didBeginSync = true
        capturedLastSyncTime = lastSyncTime
        self.completionHandler = completionHandler
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

    func simulateSuccessfulSync(_ response: ModelCharacteristics) {
        completionHandler?(response)
    }

    func simulateUnsuccessfulSync() {
        completionHandler?(nil)
    }

    func simulateLoginResponse(_ response: LoginResponse) {
        loginHandler?(response)
    }

    func simulateLoginFailure() {
        loginHandler?(nil)
    }

    func simulateMessagesResponse(response: [MessageEntity] = []) {
        messagesHandler?(response)
    }

    func simulateMessagesFailure() {
        messagesHandler?(nil)
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
