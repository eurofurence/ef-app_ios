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
    private let authenticationCoordinator: UserAuthenticationCoordinator
    private let privateMessagesController: PrivateMessagesController
    private let conventionCountdownController: ConventionCountdownController

    private let announcementsService: Announcements
    private let knowledgeService: Knowledge
    private let schedule: Schedule
    private let dealersService: Dealers
    private let significantTimeObserver: SignificantTimeObserver
    private let urlHandler: URLHandler
    private let collectThemAllService: CollectThemAll
    private let mapsService: Maps

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

        privateMessagesController = PrivateMessagesController(eventBus: eventBus,
                                                              privateMessagesAPI: privateMessagesAPI)

        authenticationCoordinator = UserAuthenticationCoordinator(eventBus: eventBus,
                                                                  clock: clock,
                                                                  credentialStore: credentialStore,
                                                                  remoteNotificationsTokenRegistration: remoteNotificationsTokenRegistration,
                                                                  loginAPI: loginAPI)

        conventionCountdownController = ConventionCountdownController(eventBus: eventBus,
                                                                      conventionStartDateRepository: conventionStartDateRepository,
                                                                      dateDistanceCalculator: dateDistanceCalculator,
                                                                      clock: clock)

        announcementsService = Announcements(eventBus: eventBus,
                                             dataStore: dataStore,
                                             imageRepository: imageRepository)

        knowledgeService = Knowledge(eventBus: eventBus,
                                     dataStore: dataStore,
                                     imageRepository: imageRepository)

        let imageCache = ImagesCache(eventBus: eventBus,
                                     imageRepository: imageRepository)

        schedule = Schedule(eventBus: eventBus,
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
        dealersService = Dealers(eventBus: eventBus,
                                 dataStore: dataStore,
                                 imageCache: imageCache,
                                 mapCoordinateRender: mapCoordinateRender)

        urlHandler = URLHandler(eventBus: eventBus, urlOpener: urlOpener)

        collectThemAllService = CollectThemAll(eventBus: eventBus,
                                               collectThemAllRequestFactory: collectThemAllRequestFactory,
                                               credentialStore: credentialStore)

        mapsService = Maps(eventBus: eventBus,
                           dataStore: dataStore,
                           imageRepository: imageRepository,
                           dealers: dealersService)

        refreshService = ConcreteRefreshService(longRunningTaskManager: longRunningTaskManager,
                                                dataStore: dataStore,
                                                syncAPI: syncAPI,
                                                imageDownloader: imageDownloader,
                                                announcementsService: announcementsService,
                                                schedule: schedule,
                                                clock: clock,
                                                eventBus: eventBus,
                                                imageCache: imageCache,
                                                imageRepository: imageRepository,
                                                knowledgeService: knowledgeService,
                                                privateMessagesController: privateMessagesController)

        privateMessagesController.refreshMessages()
    }

    lazy var services: Services = {
        return Services(notifications: self,
                        refresh: refreshService,
                        announcements: announcementsService,
                        authentication: authenticationCoordinator,
                        events: schedule,
                        dealers: dealersService,
                        knowledge: knowledgeService,
                        contentLinks: self,
                        conventionCountdown: conventionCountdownController,
                        collectThemAll: collectThemAllService,
                        maps: mapsService,
                        sessionState: sessionStateService,
                        privateMessages: privateMessagesController)
    }()

    func handleNotification(payload: [String: String], completionHandler: @escaping (NotificationContent) -> Void) {
        if payload[ApplicationNotificationKey.notificationContentKind.rawValue] == ApplicationNotificationContentKind.event.rawValue {
            guard let identifier = payload[ApplicationNotificationKey.notificationContentIdentifier.rawValue] else {
                completionHandler(.unknown)
                return
            }

            guard schedule.eventModels.contains(where: { $0.identifier.rawValue == identifier }) else {
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
        eventBus.post(DomainEvent.RemoteNotificationRegistrationSucceeded(deviceToken: deviceToken))
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
