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
    private var versionProviding: AppVersionProviding
    private var reviewPromptAppVersionRepository: ReviewPromptAppVersionRepository

    static func initialize() {
        _ = ReviewPromptController(config: .default,
                                   reviewPromptAction: StoreKitReviewPromptAction(),
                                   versionProviding: BundleAppVersionProviding.shared,
                                   reviewPromptAppVersionRepository: UserDefaultsReviewPromptAppVersionRepository(),
                                   eventsService: EurofurenceApplication.shared)
    }

    init(config: ReviewPromptController.Config,
         reviewPromptAction: ReviewPromptAction,
         versionProviding: AppVersionProviding,
         reviewPromptAppVersionRepository: ReviewPromptAppVersionRepository,
         eventsService: EventsService) {
        self.config = config
        self.reviewPromptAction = reviewPromptAction
        self.versionProviding = versionProviding
        self.reviewPromptAppVersionRepository = reviewPromptAppVersionRepository
        self.eventsService = eventsService

        eventsService.add(self)
    }

    func favouriteEventsDidChange(_ identifiers: [Event2.Identifier]) {
        let minimumNumberOfEventsFavourited: Bool = identifiers.count >= config.requiredNumberOfFavouriteEvents
        let runningDifferentAppVersionSinceLastPrompt: Bool = versionProviding.version != reviewPromptAppVersionRepository.lastPromptedAppVersion

        if minimumNumberOfEventsFavourited && runningDifferentAppVersionSinceLastPrompt {
            reviewPromptAction.showReviewPrompt()
            reviewPromptAppVersionRepository.setLastPromptedAppVersion(versionProviding.version)
        }
    }

    func eventsDidChange(to events: [Event2]) { }
    func runningEventsDidChange(to events: [Event2]) { }
    func upcomingEventsDidChange(to events: [Event2]) { }

}
