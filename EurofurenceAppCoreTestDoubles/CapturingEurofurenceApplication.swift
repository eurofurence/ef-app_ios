//
//  CapturingEurofurenceApplication.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import Foundation

public class CapturingEurofurenceApplication: EurofurenceApplicationProtocol {

    public init() {

    }

    public func fetchKnowledgeGroup(identifier: KnowledgeGroup.Identifier, completionHandler: @escaping (KnowledgeGroup) -> Void) {

    }

    public func handleRemoteNotification(payload: [String: String], completionHandler: @escaping (ApplicationPushActionResult) -> Void) {

    }

    public func openAnnouncement(identifier: Announcement.Identifier, completionHandler: @escaping (Announcement) -> Void) {

    }

    public func fetchAnnouncementImage(identifier: Announcement.Identifier, completionHandler: @escaping (Data?) -> Void) {

    }

    public func add(_ observer: RefreshServiceObserver) {

    }

    public func performRefresh() {

    }

    public func fetchContent(for identifier: Map.Identifier,
                      atX x: Int,
                      y: Int,
                      completionHandler: @escaping (Map.Content) -> Void) {

    }

    public func add(_ observer: MapsObserver) {

    }

    public func fetchImagePNGDataForMap(identifier: Map.Identifier, completionHandler: @escaping (Data) -> Void) {

    }

    public func subscribe(_ observer: CollectThemAllURLObserver) {

    }

    public func openTelegram(for identifier: Dealer.Identifier) {

    }

    public func openTwitter(for identifier: Dealer.Identifier) {

    }

    public func openWebsite(for identifier: Dealer.Identifier) {

    }

    public func fetchExtendedDealerData(for dealer: Dealer.Identifier, completionHandler: @escaping (ExtendedDealerData) -> Void) {

    }

    public func makeDealersIndex() -> DealersIndex {
        struct DummyDealersIndex: DealersIndex {
            func performSearch(term: String) {

            }

            func setDelegate(_ delegate: DealersIndexDelegate) {

            }
        }

        return DummyDealersIndex()
    }

    public func fetchIconPNGData(for identifier: Dealer.Identifier, completionHandler: @escaping (Data?) -> Void) {

    }

    public func makeEventsSchedule() -> EventsSchedule {
        struct DummyEventsSchedule: EventsSchedule {
            func setDelegate(_ delegate: EventsScheduleDelegate) { }
            func restrictEvents(to day: Day) { }
        }

        return DummyEventsSchedule()
    }

    public func makeEventsSearchController() -> EventsSearchController {
        struct DummyEventsSearchController: EventsSearchController {
            func restrictResultsToFavourites() {

            }

            func removeFavouritesEventsRestriction() {

            }

            func setResultsDelegate(_ delegate: EventsSearchControllerDelegate) {

            }

            func changeSearchTerm(_ term: String) {

            }
        }

        return DummyEventsSearchController()
    }

    public func fetchEvent(for identifier: Event.Identifier, completionHandler: @escaping (Event?) -> Void) {

    }

    public func favouriteEvent(identifier: Event.Identifier) {

    }

    public func unfavouriteEvent(identifier: Event.Identifier) {

    }

    public var localPrivateMessages: [Message] = []

    private(set) public  var capturedStoreStateResolutionHandler: (((EurofurenceDataStoreState) -> Void))?
    public func resolveDataStoreState(completionHandler: @escaping (EurofurenceDataStoreState) -> Void) {
        capturedStoreStateResolutionHandler = completionHandler
    }

    private(set) public var wasRequestedForCurrentUser = false
    private(set) fileprivate var retrieveUserCompletionHandler: ((User?) -> Void)?
    public func retrieveCurrentUser(completionHandler: @escaping (User?) -> Void) {
        wasRequestedForCurrentUser = true
        retrieveUserCompletionHandler = completionHandler
    }

    private(set) fileprivate var privateMessageFetchCompletionHandler: ((PrivateMessageResult) -> Void)?
    public func fetchPrivateMessages(completionHandler: @escaping (PrivateMessageResult) -> Void) {
        privateMessageFetchCompletionHandler = completionHandler
    }

    private(set) public var capturedLoginArguments: LoginArguments?
    private(set) public var capturedLoginHandler: ((LoginResult) -> Void)?
    public func login(_ arguments: LoginArguments, completionHandler: @escaping (LoginResult) -> Void) {
        capturedLoginArguments = arguments
        capturedLoginHandler = completionHandler
    }

    public func storeRemoteNotificationsToken(_ deviceToken: Data) {

    }

    fileprivate var privateMessageObservers = [PrivateMessagesObserver]()
    public func add(_ observer: PrivateMessagesObserver) {
        privateMessageObservers.append(observer)
    }

    private(set) public var messageMarkedAsRead: Message?
    public func markMessageAsRead(_ message: Message) {
        messageMarkedAsRead = message
    }

    public func logout(completionHandler: @escaping (LogoutResult) -> Void) {

    }

    public func add(_ observer: KnowledgeServiceObserver) {

    }

    public func fetchKnowledgeEntry(for identifier: KnowledgeEntry.Identifier, completionHandler: @escaping (KnowledgeEntry) -> Void) {

    }

    public func fetchKnowledgeGroup(identifier: KnowledgeGroup.Identifier, completionHandler: @escaping ([KnowledgeEntry]) -> Void) {

    }

    public func fetchImagesForKnowledgeEntry(identifier: KnowledgeEntry.Identifier, completionHandler: @escaping ([Data]) -> Void) {

    }

    public func add(_ observer: AnnouncementsServiceObserver) {

    }

    public func fetchAnnouncements(completionHandler: @escaping ([Announcement]) -> Void) {

    }

    public func lookupContent(for link: Link) -> LinkContentLookupResult? {
        return nil
    }

    public func setExternalContentHandler(_ externalContentHandler: ExternalContentHandler) {

    }

    private(set) public var wasToldToRefreshLocalStore = false
    fileprivate var refreshCompletionHandler: ((Error?) -> Void)?
    fileprivate var refreshProgress: Progress?
    public func refreshLocalStore(completionHandler: @escaping (Error?) -> Void) -> Progress {
        wasToldToRefreshLocalStore = true
        refreshCompletionHandler = completionHandler
        refreshProgress = Progress()

        return refreshProgress!
    }

    public func performFullStoreRefresh(completionHandler: @escaping (Error?) -> Void) -> Progress {
        wasToldToRefreshLocalStore = true
        refreshCompletionHandler = completionHandler
        refreshProgress = Progress()

        return refreshProgress!
    }

    public func add(_ observer: ConventionCountdownServiceObserver) {

    }

    public func requestPermissionsForPushNotifications() {

    }

    public func add(_ observer: AuthenticationStateObserver) {

    }

    public func add(_ observer: EventsServiceObserver) {

    }

}

// MARK: - Test Helpers

public extension CapturingEurofurenceApplication {

    public func resolveUserRetrievalWithUser(_ user: User?) {
        retrieveUserCompletionHandler?(user)
    }

    public func resolvePrivateMessagesFetch(_ result: PrivateMessageResult) {
        privateMessageFetchCompletionHandler?(result)
    }

    public func failLastRefresh() {
        struct SomeError: Error {}
        refreshCompletionHandler?(SomeError())
    }

    public func succeedLastRefresh() {
        refreshCompletionHandler?(nil)
    }

    public func updateProgressForCurrentRefresh(currentUnitCount: Int, totalUnitCount: Int) {
        refreshProgress?.totalUnitCount = Int64(totalUnitCount)
        refreshProgress?.completedUnitCount = Int64(currentUnitCount)
    }

    public func simulateMessagesLoaded(_ messages: [Message]) {
        privateMessageObservers.forEach({ $0.eurofurenceApplicationDidLoad(messages: messages) })
    }

}
