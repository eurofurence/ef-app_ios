//
//  DealerDetailLocationAndAvailabilityViewModel+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import RandomDataGeneration

extension DealerDetailLocationAndAvailabilityViewModel: RandomValueProviding {

    public static var random: DealerDetailLocationAndAvailabilityViewModel {
        return DealerDetailLocationAndAvailabilityViewModel(title: .random,
                                                            mapPNGGraphicData: .random,
                                                            limitedAvailabilityWarning: .random,
                                                            locatedInAfterDarkDealersDenMessage: .random)
    }

}
