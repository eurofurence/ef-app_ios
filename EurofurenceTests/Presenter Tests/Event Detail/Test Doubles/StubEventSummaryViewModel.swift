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
    
    let summary: EventSummaryViewModel
    private let expectedIndex: Int
    
    init(summary: EventSummaryViewModel, at index: Int) {
        self.summary = summary
        expectedIndex = index
    }
    
    var numberOfComponents: Int = .random
    
    func describe(componentAt index: Int, to visitor: EventDetailViewModelVisitor) {
        visitor.visit(summary.randomized(ifFalse: index == expectedIndex))
    }
    
    func favourite() {
        
    }
    
}
