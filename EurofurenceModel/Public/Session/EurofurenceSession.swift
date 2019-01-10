//
//  EurofurenceSession.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/08/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

public protocol EurofurenceSession: AuthenticationService,
                                    EventsService,
                                    DealersService,
                                    KnowledgeService,
                                    ContentLinksService,
                                    ConventionCountdownService,
                                    CollectThemAllService,
                                    MapsService,
                                    SessionStateService,
                                    PrivateMessagesService {
    
    var services: Services { get }

}
