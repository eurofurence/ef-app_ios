//
//  EventDescriptionViewModel.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 23/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence

extension EventDescriptionViewModel: RandomValueProviding {
    
    static var random: EventDescriptionViewModel {
        return EventDescriptionViewModel(contents: .random)
    }
    
}
