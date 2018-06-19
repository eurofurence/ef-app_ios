//
//  CapturingDealersIndexDelegate.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingDealersIndexDelegate: DealersIndexDelegate {
    
    private(set) var toldAlphabetisedDealersDidChangeToEmptyValue = false
    private(set) var capturedAlphabetisedDealerGroups = [AlphabetisedDealersGroup]()
    func alphabetisedDealersDidChange(to alphabetisedGroups: [AlphabetisedDealersGroup]) {
        toldAlphabetisedDealersDidChangeToEmptyValue = alphabetisedGroups.isEmpty
        capturedAlphabetisedDealerGroups = alphabetisedGroups
    }
    
}
