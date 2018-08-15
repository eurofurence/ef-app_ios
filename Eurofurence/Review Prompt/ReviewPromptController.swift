//
//  ReviewPromptController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct ReviewPromptController: EventsServiceObserver {

    private var reviewPromptAction: ReviewPromptAction
    private var eventsService: EventsService

    init(reviewPromptAction: ReviewPromptAction, eventsService: EventsService) {
        self.reviewPromptAction = reviewPromptAction
        self.eventsService = eventsService
        eventsService.add(self)
    }

    func favouriteEventsDidChange(_ identifiers: [Event2.Identifier]) {
        if identifiers.count > 2 {
            reviewPromptAction.showReviewPrompt()
        }
    }

    func eventsDidChange(to events: [Event2]) { }
    func runningEventsDidChange(to events: [Event2]) { }
    func upcomingEventsDidChange(to events: [Event2]) { }

}
