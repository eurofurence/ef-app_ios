//
//  ConventionCountdownComponentViewModel+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import RandomDataGeneration

extension ConventionCountdownComponentViewModel: RandomValueProviding {
    
    public static var random: ConventionCountdownComponentViewModel {
        return ConventionCountdownComponentViewModel(timeUntilConvention: .random)
    }
    
}
