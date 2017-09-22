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
    private var witnessedTutorialPushPermissionsRequest: WitnessedTutorialPushPermissionsRequest
    private var quoteGenerator: QuoteGenerator
    private var presentationStrings: PresentationStrings
    private var presentationAssets: PresentationAssets
    private var networkReachability: NetworkReachability
    private var pushPermissionsRequesting: PushPermissionsRequesting

    init() {
        routers = StubRouters()
        firstTimeLaunchProviding = StubFirstTimeLaunchStateProvider(userHasCompletedTutorial: true)
        witnessedTutorialPushPermissionsRequest = UserNotAcknowledgedPushPermissions()
        quoteGenerator = CapturingQuoteGenerator()
        presentationStrings = StubPresentationStrings()
        presentationAssets = StubPresentationAssets()
        networkReachability = ReachableWiFiNetwork()
        pushPermissionsRequesting = CapturingPushPermissionsRequesting()
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
    
    func withUserWitnessedTutorialPushPermissionsRequest(_ witnessedTutorialPushPermissionsRequest: WitnessedTutorialPushPermissionsRequest) -> PresentationTestBuilder {
        self.witnessedTutorialPushPermissionsRequest = witnessedTutorialPushPermissionsRequest
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

    func build() -> PresentationTestContext {
        let appContext = ApplicationContext(firstTimeLaunchProviding: firstTimeLaunchProviding,
                                            witnessedTutorialPushPermissionsRequest: witnessedTutorialPushPermissionsRequest,
                                            quoteGenerator: quoteGenerator,
                                            presentationStrings: presentationStrings,
                                            presentationAssets: presentationAssets,
                                            networkReachability: networkReachability,
                                            pushPermissionsRequesting: pushPermissionsRequesting)

        return PresentationTestContext(applicationContext: appContext,
                                       routers: routers,
                                       presentationStrings: presentationStrings,
                                       presentationAssets: presentationAssets)
    }

}
