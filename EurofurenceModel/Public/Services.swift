//
//  Services.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/01/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import Foundation

public protocol Services {

    var notifications: NotificationService { get }
    var refresh: RefreshService { get }
    var announcements: AnnouncementsService { get }
    var authentication: AuthenticationService { get }
    var events: EventsService { get }
    var dealers: DealersService { get }
    var knowledge: KnowledgeService { get }
    var contentLinks: ContentLinksService { get }
    var conventionCountdown: ConventionCountdownService { get }
    var collectThemAll: CollectThemAllService { get }
    var maps: MapsService { get }
    var sessionState: SessionStateService { get }
    var privateMessages: PrivateMessagesService { get }

}
