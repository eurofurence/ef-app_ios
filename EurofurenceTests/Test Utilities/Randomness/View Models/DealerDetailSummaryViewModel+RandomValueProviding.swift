//
//  DealerDetailSummaryViewModel+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 21/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

extension DealerDetailSummaryViewModel: RandomValueProviding {
    
    static var random: DealerDetailSummaryViewModel {
        return DealerDetailSummaryViewModel(artistImagePNGData: .random,
                                            title: .random,
                                            subtitle: .random)
    }
    
}
