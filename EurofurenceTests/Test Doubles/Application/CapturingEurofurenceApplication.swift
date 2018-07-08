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
    func handleRemoteNotification(payload: [String : String]) {
        
    }
    
    func openAnnouncement(identifier: Announcement2.Identifier, completionHandler: @escaping (Announcement2) -> Void) {
        
    }
    
    func add(_ observer: RefreshServiceObserver) {
        
    }
    
    func performRefresh() {
        
    }
    
    func fetchContent(for identifier: Map2.Identifier,
                      atX x: Int,
                      y: Int,
                      completionHandler: @escaping (Map2.Content) -> Void) {
        
    }
    
    func add(_ observer: MapsObserver) {
        
    }
    
    func fetchImagePNGDataForMap(identifier: Map2.Identifier, completionHandler: @escaping (Data) -> Void) {
        
    }
    
    func subscribe(_ observer: CollectThemAllURLObserver) {
        
    }
    
    func openTelegram(for identifier: Dealer2.Identifier) {
        
    }
    
    func openTwitter(for identifier: Dealer2.Identifier) {
        
    }
    
    func openWebsite(for identifier: Dealer2.Identifier) {
        
    }
    
    func fetchExtendedDealerData(for dealer: Dealer2.Identifier, completionHandler: @escaping (ExtendedDealerData) -> Void) {
        
    }
    
    func makeDealersIndex() -> DealersIndex {
        struct DummyDealersIndex: DealersIndex {
            func performSearch(term: String) {
                
            }
            
            func setDelegate(_ delegate: DealersIndexDelegate) {
                
            }
        }
        
        return DummyDealersIndex()
    }
    
    func fetchIconPNGData(for identifier: Dealer2.Identifier, completionHandler: @escaping (Data?) -> Void) {
        
    }
    
    func makeEventsSchedule() -> EventsSchedule {
        struct DummyEventsSchedule: EventsSchedule {
            func setDelegate(_ delegate: EventsScheduleDelegate) { }
            func restrictEvents(to day: Day) { }
        }
        
        return DummyEventsSchedule()
    }
    
    func makeEventsSearchController() -> EventsSearchController {
        struct DummyEventsSearchController: EventsSearchController {
            func setResultsDelegate(_ delegate: EventsSearchControllerDelegate) {
                
            }
            
            func changeSearchTerm(_ term: String) {
                
            }
        }
        
        return DummyEventsSearchController()
    }
    
    func fetchEvent(for identifier: Event2.Identifier, completionHandler: @escaping (Event2?) -> Void) {
        
    }
    
    func favouriteEvent(identifier: Event2.Identifier) {
        
    }
    
    func unfavouriteEvent(identifier: Event2.Identifier) {
        
    }
    
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
    
    func add(_ observer: AnnouncementsServiceObserver) {
        
    }
    
    func fetchAnnouncements(completionHandler: @escaping ([Announcement2]) -> Void) {
        
    }
    
    func lookupContent(for link: Link) -> LinkContentLookupResult? {
        return nil
    }
    
    func setExternalContentHandler(_ externalContentHandler: ExternalContentHandler) {
        
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
    
    func add(_ observer: ConventionCountdownServiceObserver) {
        
    }
    
    func requestPermissionsForPushNotifications() {
        
    }
    
    func add(_ observer: AuthenticationStateObserver) {
        
    }
    
    func add(_ observer: EventsServiceObserver) {
        
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
