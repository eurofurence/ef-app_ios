//
//  FakeReviewPromptAppVersionRepository.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 15/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import Foundation

class FakeReviewPromptAppVersionRepository: ReviewPromptAppVersionRepository {
    
    var lastPromptedAppVersion: String?
    
    func setLastPromptedAppVersion(_ lastPromptedAppVersion: String) {
        print("*** Recording last prompted app version: \(lastPromptedAppVersion)")
        self.lastPromptedAppVersion = lastPromptedAppVersion
    }
    
}
