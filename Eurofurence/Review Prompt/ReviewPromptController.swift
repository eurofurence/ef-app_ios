//
//  ReviewPromptController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
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
    private var appStateProviding: AppStateProviding
    private var reviewPromptAppVersionRepository: ReviewPromptAppVersionRepository

    static func initialize() {
        _ = ReviewPromptController(config: .default,
                                   reviewPromptAction: StoreKitReviewPromptAction(),
                                   versionProviding: BundleAppVersionProviding.shared,
                                   reviewPromptAppVersionRepository: UserDefaultsReviewPromptAppVersionRepository(),
                                   appStateProviding: ApplicationAppStateProviding(),
                                   eventsService: SharedModel.instance.services.events)
    }

    init(config: ReviewPromptController.Config,
         reviewPromptAction: ReviewPromptAction,
         versionProviding: AppVersionProviding,
         reviewPromptAppVersionRepository: ReviewPromptAppVersionRepository,
         appStateProviding: AppStateProviding,
         eventsService: EventsService) {
        self.config = config
        self.reviewPromptAction = reviewPromptAction
        self.versionProviding = versionProviding
        self.reviewPromptAppVersionRepository = reviewPromptAppVersionRepository
        self.appStateProviding = appStateProviding
        self.eventsService = eventsService

        eventsService.add(self)
    }

    func favouriteEventsDidChange(_ identifiers: [EventIdentifier]) {
        let minimumNumberOfEventsFavourited: Bool = identifiers.count >= config.requiredNumberOfFavouriteEvents
        let runningDifferentAppVersionSinceLastPrompt: Bool = versionProviding.version != reviewPromptAppVersionRepository.lastPromptedAppVersion

        if minimumNumberOfEventsFavourited && runningDifferentAppVersionSinceLastPrompt && appStateProviding.isAppActive {
            reviewPromptAction.showReviewPrompt()
            reviewPromptAppVersionRepository.setLastPromptedAppVersion(versionProviding.version)
        }
    }

    func eventsDidChange(to events: [Event]) { }
    func runningEventsDidChange(to events: [Event]) { }
    func upcomingEventsDidChange(to events: [Event]) { }

}
