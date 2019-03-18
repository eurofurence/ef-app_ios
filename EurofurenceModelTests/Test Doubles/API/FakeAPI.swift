//
//  FakeAPI.swift
//  EurofurenceModelTests
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
    private var messagesHandler: (([MessageCharacteristics]?) -> Void)?
    func loadPrivateMessages(authorizationToken: String,
                             completionHandler: @escaping ([MessageCharacteristics]?) -> Void) {
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
    func fetchImage(identifier: String, contentHashSha1: String, completionHandler: @escaping (Data?) -> Void) {
        downloadedImageIdentifiers.append(identifier)
        completionHandler(stubbedImageData(identifier: identifier, contentHashSha1: contentHashSha1))
    }

}

extension FakeAPI {
    
    func stubbedImage(for identifier: String?, availableImages: [ImageCharacteristics]) -> Data? {
        guard let image = availableImages.first(where: { $0.identifier == identifier }) else { return nil }
        return stubbedImageData(identifier: image.identifier, contentHashSha1: image.contentHashSha1.base64EncodedString)
    }
    
    // TODO: This "test data" is identical to CapturingImageRepository.stub
    private func stubbedImageData(identifier: String, contentHashSha1: String) -> Data? {
        return "\(identifier)_\(contentHashSha1)".data(using: .utf8)
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

    func simulateMessagesResponse(response: [MessageCharacteristics] = []) {
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

    override func fetchImage(identifier: String, contentHashSha1: String, completionHandler: @escaping (Data?) -> Void) {
        pendingFetches.append {
            super.fetchImage(identifier: identifier, contentHashSha1: contentHashSha1, completionHandler: completionHandler)
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
