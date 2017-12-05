//
//  CapturingEurofurenceApplication.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence

class CapturingEurofurenceApplication: EurofurenceApplicationProtocol {
    
    var localPrivateMessages: [Message] = []
    
    private(set) var wasRequestedForCurrentUser = false
    private(set) fileprivate var retrieveUserCompletionHandler: ((User?) -> Void)?
    func retrieveCurrentUser(completionHandler: @escaping (User?) -> Void) {
        wasRequestedForCurrentUser = true
        retrieveUserCompletionHandler = completionHandler
    }
    
    private(set) fileprivate var privateMessageFetchCompletionHandler: ((PrivateMessageResult) -> Void)?
    func fetchPrivateMessages(completionHandler: @escaping (PrivateMessageResult) -> Void) {
        privateMessageFetchCompletionHandler = completionHandler
    }
    
    private(set) var capturedLoginArguments: LoginArguments?
    private(set) var capturedLoginHandler: ((LoginResult) -> Void)?
    func login(_ arguments: LoginArguments, completionHandler: @escaping (LoginResult) -> Void) {
        capturedLoginArguments = arguments
        capturedLoginHandler = completionHandler
    }
    
}

// MARK: - Test Helpers

extension CapturingEurofurenceApplication {
    
    func resolveUserRetrievalWithUser(_ user: User?) {
        retrieveUserCompletionHandler?(user)
    }
    
    func resolvePrivateMessagesFetch(_ result: PrivateMessageResult) {
        privateMessageFetchCompletionHandler?(result)
    }
    
}
