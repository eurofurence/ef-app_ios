//
//  CapturingDealersViewModel+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 18/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import Foundation
import RandomDataGeneration

extension CapturingDealersViewModel: RandomValueProviding {

    public static var random: CapturingDealersViewModel {
        return CapturingDealersViewModel(dealerGroups: .random)
    }

}
