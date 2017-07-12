//
//  PresentationTier.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import UIKit

struct DummyUserAcknowledgedPushPermissionsRequestStateProviding: UserAcknowledgedPushPermissionsRequestStateProviding {

    var userHasAcknowledgedRequestForPushPermissions: Bool {
        return true
    }

    func markUserAsAcknowledgingPushPermissionsRequest() {

    }

}

struct DummyPushPermissionsRequesting: PushPermissionsRequesting {

    func requestPushPermissions(completionHandler: @escaping () -> Void) {
        completionHandler()
    }

}

struct PresentationTier {

    static func assemble(window: UIWindow) {
        BootstrappingModule.bootstrap(context: makeAppContext(),
                                      routers: StoryboardRouters(window: window))
    }

    private static func makeAppContext() -> ApplicationContext {
        return ApplicationContext(firstTimeLaunchProviding: UserDefaultsTutorialStateProvider(userDefaults: .standard),
                                  userAcknowledgedPushPermissionsRequest: DummyUserAcknowledgedPushPermissionsRequestStateProviding(),
                                  quoteGenerator: EgyptianQuoteGenerator(),
                                  presentationStrings: UnlocalizedPresentationStrings(),
                                  presentationAssets: ApplicationPresentationAssets(),
                                  networkReachability: SwiftNetworkReachability.shared,
                                  pushPermissionsRequesting: DummyPushPermissionsRequesting())
    }

}
