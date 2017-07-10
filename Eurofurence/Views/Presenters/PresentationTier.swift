//
//  PresentationTier.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import UIKit

struct PresentationTier {

    static func assemble(window: UIWindow) -> PresentationTier {
        return PresentationTier(window: window)
    }

    private var routers: StoryboardRouters
    private var finishedTutorialProvider: UserDefaultsTutorialStateProvider

    private init(window: UIWindow) {
        self.routers = StoryboardRouters(window: window)
        self.finishedTutorialProvider = UserDefaultsTutorialStateProvider(userDefaults: .standard)
        let appContext = ApplicationContext(firstTimeLaunchProviding: finishedTutorialProvider,
                                            tutorialItems: makeTutorialItems(),
                                            quoteGenerator: EgyptianQuoteGenerator(),
                                            presentationStrings: UnlocalizedPresentationStrings(),
                                            presentationAssets: ApplicationPresentationAssets())

        BootstrappingModule.bootstrap(context: appContext, routers: routers)
    }

    private func makeTutorialItems() -> [TutorialPageInfo] {
        let action = TutorialBlockAction { }
        let beginDownloadAction = TutorialPageAction(actionDescription: "Begin Download",
                                                     action: action)
        let beginDownloadItem = TutorialPageInfo(image: #imageLiteral(resourceName: "tuto02_informationIcon"),
                                                 title: "Offline Usage",
                                                 description: "The Eurofurence app is intended to remain fully functional while offline. To do this, we need to download a few megabytes of data. This may take several minutes depending upon the speed of your connection.",
                                                 primaryAction: beginDownloadAction)

        return [beginDownloadItem]
    }

}
