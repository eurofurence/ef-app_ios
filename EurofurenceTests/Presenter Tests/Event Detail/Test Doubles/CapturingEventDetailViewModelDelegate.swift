//
//  CapturingEventDetailViewModelDelegate.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 01/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingEventDetailViewModelDelegate: EventDetailViewModelDelegate {
    
    private(set) var toldEventFavourited = false
    func eventFavourited() {
        toldEventFavourited = true
    }
    
    func eventUnfavourited() {
        
    }
    
}
