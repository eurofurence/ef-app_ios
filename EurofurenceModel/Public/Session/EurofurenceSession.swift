//
//  EurofurenceSession.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

public protocol EurofurenceSession: NotificationService,
                                    RefreshService,
                                    AnnouncementsService,
                                    AuthenticationService,
                                    EventsService,
                                    DealersService,
                                    KnowledgeService,
                                    LinkLookupService,
                                    ConventionCountdownService,
                                    CollectThemAllService,
                                    MapsService,
                                    SessionStateService,
                                    PrivateMessagesService {

    func setExternalContentHandler(_ externalContentHandler: ExternalContentHandler)
    func storeRemoteNotificationsToken(_ deviceToken: Data)

}
