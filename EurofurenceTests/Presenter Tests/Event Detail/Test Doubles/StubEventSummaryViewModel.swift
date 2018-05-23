//
//  StubEventDetailViewModel.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 20/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

struct StubEventSummaryViewModel: EventDetailViewModel {
    
    var summary: EventSummaryViewModel = .random
    
    func describe(componentAt index: Int, to visitor: EventDetailViewModelVisitor) {
        visitor.visit(summary)
    }
    
}
