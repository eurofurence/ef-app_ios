//
//  ConcreteNotificationService.swift
//  EurofurenceModel
//
//  Created by Thomas Sherwood on 20/01/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import EventBus
import Foundation

struct ConcreteNotificationService: NotificationService {

    var eventBus: EventBus
    var eventsService: ConcreteEventsService
    var announcementsService: ConcreteAnnouncementsService
    var refreshService: ConcreteRefreshService

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

}
