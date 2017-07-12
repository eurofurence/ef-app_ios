//
//  PresentationTier.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import UIKit

struct DummyUserPushPermissionsState: UserPushPermissionsState {

    func markPermittedRegisteringForPushNotifications() {

    }

}

struct PresentationTier {

    static let pushRequesting = ApplicationPushPermissionsRequesting()

    static func assemble(window: UIWindow) {
        BootstrappingModule.bootstrap(context: makeAppContext(),
                                      routers: StoryboardRouters(window: window))
    }

    private static func makeAppContext() -> ApplicationContext {
        return ApplicationContext(firstTimeLaunchProviding: UserDefaultsTutorialStateProvider(userDefaults: .standard),
                                  userAcknowledgedPushPermissionsRequest: UserDefaultsUserAcknowledgedPushPermissionsRequestStateProviding(userDefaults: .standard),
                                  quoteGenerator: EgyptianQuoteGenerator(),
                                  presentationStrings: UnlocalizedPresentationStrings(),
                                  presentationAssets: ApplicationPresentationAssets(),
                                  networkReachability: SwiftNetworkReachability.shared,
                                  pushPermissionsRequesting: pushRequesting,
                                  userPushPermissionsState: DummyUserPushPermissionsState())
    }

}
