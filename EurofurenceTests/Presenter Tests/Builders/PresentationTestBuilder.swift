//
//  PresentationTestBuilder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

struct PresentationTestContext {

    var applicationContext: ApplicationContext
    var routers: Routers
    var presentationStrings: PresentationStrings
    var presentationAssets: PresentationAssets

    func bootstrap() {
        BootstrappingModule.bootstrap(context: applicationContext, routers: routers)
    }

}

class PresentationTestBuilder {

    private var routers: Routers
    private var firstTimeLaunchProviding: UserCompletedTutorialStateProviding
    private var acknowledgedPushPermissions: AcknowledgedPushPermissionsRequest
    private var quoteGenerator: QuoteGenerator
    private var presentationStrings: PresentationStrings
    private var presentationAssets: PresentationAssets
    private var networkReachability: NetworkReachability
    private var pushPermissionsRequesting: PushPermissionsRequesting
    private var optedIntoPush: UserOptedIntoPushNotifications

    init() {
        routers = StubRouters()
        firstTimeLaunchProviding = StubFirstTimeLaunchStateProvider(userHasCompletedTutorial: true)
        acknowledgedPushPermissions = UserNotAcknowledgedPushPermissions()
        quoteGenerator = CapturingQuoteGenerator()
        presentationStrings = StubPresentationStrings()
        presentationAssets = StubPresentationAssets()
        networkReachability = ReachableWiFiNetwork()
        pushPermissionsRequesting = CapturingPushPermissionsRequesting()
        optedIntoPush = CapturingUserOptedIntoPushNotifications()
    }

    func withRouters(_ routers: Routers) -> PresentationTestBuilder {
        self.routers = routers
        return self
    }

    func forShowingTutorial() -> PresentationTestBuilder {
        firstTimeLaunchProviding = StubFirstTimeLaunchStateProvider(userHasCompletedTutorial: false)
        return self
    }
    
    func withUserCompletedTutorialStateProviding(_ firstTimeLaunchProviding: UserCompletedTutorialStateProviding) -> PresentationTestBuilder {
        self.firstTimeLaunchProviding = firstTimeLaunchProviding
        return self
    }
    
    func withUserAcknowledgedPushPermissionsRequest(_ acknowledgedPushPermissions: AcknowledgedPushPermissionsRequest) -> PresentationTestBuilder {
        self.acknowledgedPushPermissions = acknowledgedPushPermissions
        return self
    }

    func withQuoteGenerator(_ quoteGenerator: QuoteGenerator) -> PresentationTestBuilder {
        self.quoteGenerator = quoteGenerator
        return self
    }

    func withNetworkReachability(_ networkReachability: NetworkReachability) -> PresentationTestBuilder {
        self.networkReachability = networkReachability
        return self
    }

    func withPushPermissionsRequesting(_ pushPermissionsRequesting: PushPermissionsRequesting) -> PresentationTestBuilder {
        self.pushPermissionsRequesting = pushPermissionsRequesting
        return self
    }

    func withUserOptedIntoPushNotifications(_ optedIntoPush: UserOptedIntoPushNotifications) -> PresentationTestBuilder {
        self.optedIntoPush = optedIntoPush
        return self
    }

    func build() -> PresentationTestContext {
        let appContext =  ApplicationContext(firstTimeLaunchProviding: firstTimeLaunchProviding,
                                             acknowledgedPushPermissions: acknowledgedPushPermissions,
                                             quoteGenerator: quoteGenerator,
                                             presentationStrings: presentationStrings,
                                             presentationAssets: presentationAssets,
                                             networkReachability: networkReachability,
                                             pushPermissionsRequesting: pushPermissionsRequesting,
                                             optedIntoPush: optedIntoPush)

        return PresentationTestContext(applicationContext: appContext,
                                       routers: routers,
                                       presentationStrings: presentationStrings,
                                       presentationAssets: presentationAssets)
    }

}
