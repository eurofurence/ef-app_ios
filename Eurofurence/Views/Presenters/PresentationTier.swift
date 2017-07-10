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
    var wifiReachable: Bool = false
}

struct PresentationTier {

    static func assemble(window: UIWindow) {
        BootstrappingModule.bootstrap(context: makeAppContext(),
                                      routers: StoryboardRouters(window: window))
    }

    private static func makeAppContext() -> ApplicationContext {
        return ApplicationContext(firstTimeLaunchProviding: UserDefaultsTutorialStateProvider(userDefaults: .standard),
                                  quoteGenerator: EgyptianQuoteGenerator(),
                                  presentationStrings: UnlocalizedPresentationStrings(),
                                  presentationAssets: ApplicationPresentationAssets(),
                                  networkReachability: DummyNetworkReachability())
    }

}
