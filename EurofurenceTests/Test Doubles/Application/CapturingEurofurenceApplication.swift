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
    
    fileprivate var privateMessageObservers = [PrivateMessagesObserver]()
    func add(_ observer: PrivateMessagesObserver) {
        privateMessageObservers.append(observer)
    }
    
    private(set) var messageMarkedAsRead: Message?
    func markMessageAsRead(_ message: Message) {
        messageMarkedAsRead = message
    }
    
    func logout(completionHandler: @escaping (LogoutResult) -> Void) {
        
    }
    
    func fetchKnowledgeGroups(completionHandler: @escaping ([KnowledgeGroup2]) -> Void) {
        
    }
    
    func fetchAnnouncements(completionHandler: @escaping ([Announcement2]) -> Void) {
        
    }
    
    func lookupContent(for link: Link) -> LinkContentLookupResult? {
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
    
    func observeDaysUntilConvention(using observer: DaysUntilConventionServiceObserver) {
        
    }
    
    func requestPermissionsForPushNotifications() {
        
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
    
    func simulateMessagesLoaded(_ messages: [Message]) {
        privateMessageObservers.forEach({ $0.eurofurenceApplicationDidLoad(messages: messages) })
    }
    
}
