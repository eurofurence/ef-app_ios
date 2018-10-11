//
//  DealerDetailSummaryViewModel+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 21/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import Foundation
import RandomDataGeneration

extension DealerDetailSummaryViewModel: RandomValueProviding {

    public static var random: DealerDetailSummaryViewModel {
        return DealerDetailSummaryViewModel(artistImagePNGData: .random,
                                            title: .random,
                                            subtitle: .random,
                                            categories: .random,
                                            shortDescription: .random,
                                            website: .random,
                                            twitterHandle: .random,
                                            telegramHandle: .random)
    }

}
