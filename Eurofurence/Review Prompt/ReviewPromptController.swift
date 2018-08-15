//
//  ReviewPromptController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct ReviewPromptController: EventsServiceObserver {

    struct Config {
        static let `default` = Config(requiredNumberOfFavouriteEvents: 3)

        var requiredNumberOfFavouriteEvents: Int
    }

    private var config: ReviewPromptController.Config
    private var reviewPromptAction: ReviewPromptAction
    private var eventsService: EventsService

    init(config: ReviewPromptController.Config,
         reviewPromptAction: ReviewPromptAction,
         eventsService: EventsService) {
        self.config = config
        self.reviewPromptAction = reviewPromptAction
        self.eventsService = eventsService
        eventsService.add(self)
    }

    func favouriteEventsDidChange(_ identifiers: [Event2.Identifier]) {
        if identifiers.count > config.requiredNumberOfFavouriteEvents {
            reviewPromptAction.showReviewPrompt()
        }
    }

    func eventsDidChange(to events: [Event2]) { }
    func runningEventsDidChange(to events: [Event2]) { }
    func upcomingEventsDidChange(to events: [Event2]) { }

}
