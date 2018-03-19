//
//  CapturingEurofurenceApplication.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingEurofurenceApplication: EurofurenceApplicationProtocol {
    
    var localPrivateMessages: [Message] = []
    
    private(set) var capturedStoreStateResolutionHandler: (((EurofurenceDataStoreState) -> Void))?
    func resolveDataStoreState(completionHandler: @escaping (EurofurenceDataStoreState) -> Void) {
        capturedStoreStateResolutionHandler = completionHandler
    }
    
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
    
    func storeRemoteNotificationsToken(_ deviceToken: Data) {
        
    }
    
    func markMessageAsRead(_ message: Message) {
        
    }
    
    func logout(completionHandler: @escaping (LogoutResult) -> Void) {
        
    }
    
    func fetchKnowledgeGroups(completionHandler: @escaping ([KnowledgeGroup2]) -> Void) {
        
    }
    
    func resolveAction(for link: Link) -> LinkRouterAction? {
        return nil
    }
    
    private(set) var wasToldToRefreshLocalStore = false
    fileprivate var refreshCompletionHandler: ((Error?) -> Void)?
    fileprivate var refreshProgress: Progress?
    func refreshLocalStore(completionHandler: @escaping (Error?) -> Void) -> Progress {
        wasToldToRefreshLocalStore = true
        refreshCompletionHandler = completionHandler
        refreshProgress = Progress()
        
        return refreshProgress!
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
    
    func failLastRefresh() {
        struct SomeError: Error {}
        refreshCompletionHandler?(SomeError())
    }
    
    func succeedLastRefresh() {
        refreshCompletionHandler?(nil)
    }
    
    func updateProgressForCurrentRefresh(currentUnitCount: Int, totalUnitCount: Int) {
        refreshProgress?.totalUnitCount = Int64(totalUnitCount)
        refreshProgress?.completedUnitCount = Int64(currentUnitCount)
    }
    
}
