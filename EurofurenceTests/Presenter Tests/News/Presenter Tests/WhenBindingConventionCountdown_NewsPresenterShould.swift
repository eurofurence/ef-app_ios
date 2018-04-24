//
//  WhenBindingConventionCountdown_NewsPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

struct CountdownViewModel: NewsViewModel {
    
    var countdownViewModel: ConventionCountdownComponentViewModel
    
    var numberOfComponents: Int {
        return 1
    }
    
    func numberOfItemsInComponent(at index: Int) -> Int {
        return 1
    }
    
    func titleForComponent(at index: Int) -> String? {
        return "Countdown"
    }
    
    func describeComponent(at indexPath: IndexPath, to visitor: NewsViewModelVisitor) {
        visitor.visit(countdownViewModel)
    }
    
}

class WhenBindingConventionCountdown_NewsPresenterShould: XCTestCase {
    
    func testSetTheTimeRemainingOntoTheCountdownWidgetScene() {
        let countdownComponentViewModel = ConventionCountdownComponentViewModel.random
        let viewModel = CountdownViewModel(countdownViewModel: countdownComponentViewModel)
        let newsInteractor = StubNewsInteractor(viewModel: viewModel)
        let context = NewsPresenterTestBuilder().with(newsInteractor).build()
        context.simulateNewsSceneWillAppear()
        _ = context.sceneFactory.stubbedScene.bindComponent(at: IndexPath(item: 0, section: 0))
        
        XCTAssertEqual(countdownComponentViewModel.timeUntilConvention,
                       context.newsScene.stubbedCountdownComponent.capturedTimeUntilConvention)
    }
    
}
