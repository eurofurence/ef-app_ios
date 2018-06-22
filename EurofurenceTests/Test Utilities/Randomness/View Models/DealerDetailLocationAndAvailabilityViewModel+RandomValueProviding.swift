//
//  DealerDetailLocationAndAvailabilityViewModel+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence

extension DealerDetailLocationAndAvailabilityViewModel: RandomValueProviding {
    
    static var random: DealerDetailLocationAndAvailabilityViewModel {
        return DealerDetailLocationAndAvailabilityViewModel(mapPNGGraphicData: .random,
                                                            limitedAvailabilityWarning: .random,
                                                            locatedInAfterDarkDealersDenMessage: .random)
    }
    
}
