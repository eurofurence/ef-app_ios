//
//  UserWidgetComponentViewModel+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 20/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import RandomDataGeneration

extension UserWidgetComponentViewModel: RandomValueProviding {

    public static var random: UserWidgetComponentViewModel {
        return UserWidgetComponentViewModel(prompt: .random, detailedPrompt: .random, hasUnreadMessages: .random)
    }

}
