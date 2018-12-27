//
//  StubFirstTimeLaunchStateProvider.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import Foundation

class StubFirstTimeLaunchStateProvider: UserCompletedTutorialStateProviding {

    var userHasCompletedTutorial: Bool

    init(userHasCompletedTutorial: Bool) {
        self.userHasCompletedTutorial = userHasCompletedTutorial
    }

    private(set) var didMarkTutorialAsComplete = false
    func markTutorialAsComplete() {
        didMarkTutorialAsComplete = true
    }

}
