//
//  ConcreteSession.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 14/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import EventBus
import Foundation

class ConcreteSession: EurofurenceSession,
                       NotificationService,
                       ContentLinksService {

    private let eventBus = EventBus()

    private let sessionStateService: ConcreteSessionStateService
    private let refreshService: ConcreteRefreshService

    private let remoteNotificationRegistrationController: RemoteNotificationRegistrationController
    private let authenticationService: ConcreteAuthenticationService
    private let privateMessagesService: ConcretePrivateMessagesService
    private let conventionCountdownService: ConcreteConventionCountdownService

    private let announcementsService: ConcreteAnnouncementsService
    private let knowledgeService: ConcreteKnowledgeService
    private let eventsService: ConcreteEventsService
    private let dealersService: ConcreteDealersService
    private let significantTimeObserver: SignificantTimeObserver
    private let urlHandler: URLHandler
    private let collectThemAllService: ConcreteCollectThemAllService
    private let mapsService: ConcreteMapsService

    init(userPreferences: UserPreferences,
         dataStore: DataStore,
         remoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration?,
         pushPermissionsRequester: PushPermissionsRequester?,
         clock: Clock,
         credentialStore: CredentialStore,
         loginAPI: LoginAPI,
         privateMessagesAPI: PrivateMessagesAPI,
         syncAPI: SyncAPI,
         imageAPI: ImageAPI,
         dateDistanceCalculator: DateDistanceCalculator,
         conventionStartDateRepository: ConventionStartDateRepository,
         timeIntervalForUpcomingEventsSinceNow: TimeInterval,
         imageRepository: ImageRepository,
         significantTimeChangeAdapter: SignificantTimeChangeAdapter?,
         urlOpener: URLOpener?,
         collectThemAllRequestFactory: CollectThemAllRequestFactory,
         longRunningTaskManager: LongRunningTaskManager?,
         notificationScheduler: NotificationScheduler?,
         hoursDateFormatter: HoursDateFormatter,
         mapCoordinateRender: MapCoordinateRender?,
         forceRefreshRequired: ForceRefreshRequired) {

        pushPermissionsRequester?.requestPushPermissions()

        sessionStateService = ConcreteSessionStateService(forceRefreshRequired: forceRefreshRequired,
                                                          userPreferences: userPreferences,
                                                          dataStore: dataStore)

        remoteNotificationRegistrationController = RemoteNotificationRegistrationController(eventBus: eventBus,
                                                                                            remoteNotificationsTokenRegistration: remoteNotificationsTokenRegistration)

        privateMessagesService = ConcretePrivateMessagesService(eventBus: eventBus,
                                                                privateMessagesAPI: privateMessagesAPI)

        authenticationService = ConcreteAuthenticationService(eventBus: eventBus,
                                                              clock: clock,
                                                              credentialStore: credentialStore,
                                                              remoteNotificationsTokenRegistration: remoteNotificationsTokenRegistration,
                                                              loginAPI: loginAPI)

        conventionCountdownService = ConcreteConventionCountdownService(eventBus: eventBus,
                                                                        conventionStartDateRepository: conventionStartDateRepository,
                                                                        dateDistanceCalculator: dateDistanceCalculator,
                                                                        clock: clock)

        announcementsService = ConcreteAnnouncementsService(eventBus: eventBus,
                                                            dataStore: dataStore,
                                                            imageRepository: imageRepository)

        knowledgeService = ConcreteKnowledgeService(eventBus: eventBus,
                                                    dataStore: dataStore,
                                                    imageRepository: imageRepository)

        let imageCache = ImagesCache(eventBus: eventBus,
                                     imageRepository: imageRepository)

        eventsService = ConcreteEventsService(eventBus: eventBus,
                                              dataStore: dataStore,
                                              imageCache: imageCache,
                                              clock: clock,
                                              timeIntervalForUpcomingEventsSinceNow: timeIntervalForUpcomingEventsSinceNow,
                                              notificationScheduler: notificationScheduler,
                                              userPreferences: userPreferences,
                                              hoursDateFormatter: hoursDateFormatter)

        let imageDownloader = ImageDownloader(eventBus: eventBus,
                                              imageAPI: imageAPI,
                                              imageRepository: imageRepository)

        significantTimeObserver = SignificantTimeObserver(significantTimeChangeAdapter: significantTimeChangeAdapter,
                                                          eventBus: eventBus)
        dealersService = ConcreteDealersService(eventBus: eventBus,
                                                dataStore: dataStore,
                                                imageCache: imageCache,
                                                mapCoordinateRender: mapCoordinateRender)

        urlHandler = URLHandler(eventBus: eventBus, urlOpener: urlOpener)

        collectThemAllService = ConcreteCollectThemAllService(eventBus: eventBus,
                                                              collectThemAllRequestFactory: collectThemAllRequestFactory,
                                                              credentialStore: credentialStore)

        mapsService = ConcreteMapsService(eventBus: eventBus,
                                          dataStore: dataStore,
                                          imageRepository: imageRepository,
                                          dealers: dealersService)

        refreshService = ConcreteRefreshService(longRunningTaskManager: longRunningTaskManager,
                                                dataStore: dataStore,
                                                syncAPI: syncAPI,
                                                imageDownloader: imageDownloader,
                                                announcementsService: announcementsService,
                                                schedule: eventsService,
                                                clock: clock,
                                                eventBus: eventBus,
                                                imageCache: imageCache,
                                                imageRepository: imageRepository,
                                                knowledgeService: knowledgeService,
                                                privateMessagesController: privateMessagesService)

        privateMessagesService.refreshMessages()
    }

    lazy var services: Services = {
        return Services(notifications: self,
                        refresh: refreshService,
                        announcements: announcementsService,
                        authentication: authenticationService,
                        events: eventsService,
                        dealers: dealersService,
                        knowledge: knowledgeService,
                        contentLinks: self,
                        conventionCountdown: conventionCountdownService,
                        collectThemAll: collectThemAllService,
                        maps: mapsService,
                        sessionState: sessionStateService,
                        privateMessages: privateMessagesService)
    }()

    func handleNotification(payload: [String: String], completionHandler: @escaping (NotificationContent) -> Void) {
        if payload[ApplicationNotificationKey.notificationContentKind.rawValue] == ApplicationNotificationContentKind.event.rawValue {
            guard let identifier = payload[ApplicationNotificationKey.notificationContentIdentifier.rawValue] else {
                completionHandler(.unknown)
                return
            }

            guard eventsService.eventModels.contains(where: { $0.identifier.rawValue == identifier }) else {
                completionHandler(.unknown)
                return
            }

            let action = NotificationContent.event(EventIdentifier(identifier))
            completionHandler(action)

            return
        }

        refreshService.refreshLocalStore { (error) in
            if error == nil {
                if let announcementIdentifier = payload["announcement_id"] {
                    let identifier = AnnouncementIdentifier(announcementIdentifier)
                    if self.announcementsService.models.contains(where: { $0.identifier == identifier }) {
                        completionHandler(.announcement(identifier))
                    } else {
                        completionHandler(.invalidatedAnnouncement)
                    }
                } else {
                    completionHandler(.successfulSync)
                }
            } else {
                completionHandler(.failedSync)
            }
        }
    }

    func storeRemoteNotificationsToken(_ deviceToken: Data) {
        eventBus.post(DomainEvent.RemoteNotificationTokenAvailable(deviceToken: deviceToken))
    }

    func setExternalContentHandler(_ externalContentHandler: ExternalContentHandler) {
        urlHandler.externalContentHandler = externalContentHandler
    }

    func lookupContent(for link: Link) -> LinkContentLookupResult? {
        guard let urlString = link.contents as? String, let url = URL(string: urlString) else { return nil }

        if let scheme = url.scheme, scheme == "https" || scheme == "http" {
            return .web(url)
        }

        return .externalURL(url)
    }

}
