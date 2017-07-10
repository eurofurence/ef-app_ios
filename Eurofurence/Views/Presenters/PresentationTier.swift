//
//  PresentationTier.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import UIKit

struct DummyNetworkReachability: NetworkReachability {
    var wifiReachable: Bool = true
}

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
                                            quoteGenerator: EgyptianQuoteGenerator(),
                                            presentationStrings: UnlocalizedPresentationStrings(),
                                            presentationAssets: ApplicationPresentationAssets(),
                                            networkReachability: DummyNetworkReachability())

        BootstrappingModule.bootstrap(context: appContext, routers: routers)
    }

}
