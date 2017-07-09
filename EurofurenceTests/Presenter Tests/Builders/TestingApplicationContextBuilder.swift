//
//  TestingApplicationContextBuilder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class TestingApplicationContextBuilder {

    var firstTimeLaunchProviding: UserCompletedTutorialStateProviding
    var tutorialItems: [TutorialPageInfo]

    init() {
        firstTimeLaunchProviding = StubFirstTimeLaunchStateProvider(userHasCompletedTutorial: true)
        tutorialItems = []
    }

    func forShowingTutorial() -> TestingApplicationContextBuilder {
        firstTimeLaunchProviding = StubFirstTimeLaunchStateProvider(userHasCompletedTutorial: false)
        return self
    }
    
    func withUserCompletedTutorialStateProviding(_ firstTimeLaunchProviding: UserCompletedTutorialStateProviding) -> TestingApplicationContextBuilder {
        self.firstTimeLaunchProviding = firstTimeLaunchProviding
        return self
    }

    func withTutorialItems(_ tutorialItems: [TutorialPageInfo]) -> TestingApplicationContextBuilder {
        self.tutorialItems = tutorialItems
        return self
    }

    func build() -> ApplicationContext {
        return ApplicationContext(firstTimeLaunchProviding: firstTimeLaunchProviding,
                                  tutorialItems: tutorialItems)
    }

}
