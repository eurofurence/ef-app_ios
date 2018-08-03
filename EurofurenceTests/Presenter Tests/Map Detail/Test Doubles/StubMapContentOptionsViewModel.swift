//
//  StubMapContentOptionsViewModel.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 03/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

struct StubMapContentOptionsViewModel: MapContentOptionsViewModel {
    
    var optionsHeading: String
    var options: [String]
    
}

extension StubMapContentOptionsViewModel: RandomValueProviding {
    
    static var random: StubMapContentOptionsViewModel {
        return StubMapContentOptionsViewModel(optionsHeading: .random, options: .random)
    }
    
}
