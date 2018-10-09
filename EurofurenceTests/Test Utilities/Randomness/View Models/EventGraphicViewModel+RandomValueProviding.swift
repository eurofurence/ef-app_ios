//
//  EventGraphicViewModel+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 23/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import RandomDataGeneration

extension EventGraphicViewModel: RandomValueProviding {
    
    public static var random: EventGraphicViewModel {
        return EventGraphicViewModel(pngGraphicData: .random)
    }
    
}
