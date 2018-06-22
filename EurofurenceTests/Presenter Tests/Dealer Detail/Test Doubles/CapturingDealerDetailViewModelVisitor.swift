//
//  CapturingDealerDetailViewModelVisitor.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingDealerDetailViewModelVisitor: DealerDetailViewModelVisitor {
    
    private(set) var visitedSummary: DealerDetailSummaryViewModel?
    func visit(_ summary: DealerDetailSummaryViewModel) {
        visitedSummary = summary
    }
    
    func visit(_ location: DealerDetailLocationAndAvailabilityViewModel) {
        
    }
    
    func visit(_ aboutTheArtist: DealerDetailAboutTheArtistViewModel) {
        
    }
    
    func visit(_ aboutTheArt: DealerDetailAboutTheArtViewModel) {
        
    }
    
}
