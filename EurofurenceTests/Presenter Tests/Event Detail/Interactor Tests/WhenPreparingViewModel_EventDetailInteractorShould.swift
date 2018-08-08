//
//  WhenPreparingViewModel_EventDetailInteractorShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 21/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class CapturingEventDetailViewModelVisitor: EventDetailViewModelVisitor {
    
    private(set) var visitedViewModels = [AnyHashable]()
    
    private(set) var visitedEventSummary: EventSummaryViewModel?
    func visit(_ summary: EventSummaryViewModel) {
        visitedViewModels.append(summary)
    }
    
    func visit(_ description: EventDescriptionViewModel) {
        visitedViewModels.append(description)
    }
    
    func visit(_ graphic: EventGraphicViewModel) {
        visitedViewModels.append(graphic)
    }
    
    func visit(_ sponsorsOnlyMessage: EventSponsorsOnlyWarningViewModel) {
        visitedViewModels.append(sponsorsOnlyMessage)
    }
    
    func visit(_ superSponsorsOnlyMessage: EventSuperSponsorsOnlyWarningViewModel) {
        visitedViewModels.append(superSponsorsOnlyMessage)
    }
    
    func visit(_ artShowMessage: EventArtShowMessageViewModel) {
        visitedViewModels.append(artShowMessage)
    }
    
    func visit(_ kageMessage: EventKageMessageViewModel) {
        visitedViewModels.append(kageMessage)
    }
    
    func visit(_ dealersDenMessage: EventDealersDenMessageViewModel) {
        visitedViewModels.append(dealersDenMessage)
    }
    
    func visit(_ mainStageMessage: EventMainStageMessageViewModel) {
        visitedViewModels.append(mainStageMessage)
    }
    
    func visit(_ photoshootMessage: EventPhotoshootMessageViewModel) {
        visitedViewModels.append(photoshootMessage)
    }
    
}

class WhenPreparingViewModel_EventDetailInteractorShould: XCTestCase {
    
    var context: EventDetailInteractorTestBuilder.Context!
    
    override func setUp() {
        super.setUp()
        
        context = EventDetailInteractorTestBuilder().build()
    }
    
    func testProduceViewModelWithExpectedNumberOfComponents() {
        XCTAssertEqual(3, context.viewModel?.numberOfComponents)
    }
    
    func testProduceExpectedGraphicViewModelAtIndexZero() {
        let visitor = CapturingEventDetailViewModelVisitor()
        context.viewModel?.describe(componentAt: 0, to: visitor)
        
        XCTAssertEqual([context.makeExpectedEventGraphicViewModel()], visitor.visitedViewModels)
    }
    
    func testProduceExpectedSummaryViewModelAtIndexOne() {
        let visitor = CapturingEventDetailViewModelVisitor()
        context.viewModel?.describe(componentAt: 1, to: visitor)
        
        XCTAssertEqual([context.makeExpectedEventSummaryViewModel()], visitor.visitedViewModels)
    }
    
    func testProduceExpectedDescriptionViewModelAtIndexTwo() {
        let visitor = CapturingEventDetailViewModelVisitor()
        context.viewModel?.describe(componentAt: 2, to: visitor)
        
        XCTAssertEqual([context.makeExpectedEventDescriptionViewModel()], visitor.visitedViewModels)
    }
    
}
