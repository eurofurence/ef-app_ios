//
//  DealerViewModel.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 18/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

extension DealerViewModel: RandomValueProviding {
    
    static var random: DealerViewModel {
        return DealerViewModel(title: .random, subtitle: .random)
    }
    
}
