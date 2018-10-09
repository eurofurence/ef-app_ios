//
//  WhenSceneInstigatesPullToRefresh_NewsPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 29/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class WhenSceneInstigatesPullToRefresh_NewsPresenterShould: XCTestCase {
    
    func testTellTheInteractorToRefresh() {
        let newsInteractor = FakeNewsInteractor()
        let context = NewsPresenterTestBuilder().with(newsInteractor).build()
        context.simulateNewsSceneDidLoad()
        context.simulateNewsSceneDidPerformRefreshAction()
        
        XCTAssertTrue(newsInteractor.didRefresh)
    }
    
    func testTellTheSceneToHideTheRefreshIndicatorWhenRefreshFinishes() {
        let newsInteractor = FakeNewsInteractor()
        let context = NewsPresenterTestBuilder().with(newsInteractor).build()
        context.simulateNewsSceneDidLoad()
        context.simulateNewsSceneDidPerformRefreshAction()
        newsInteractor.simulateRefreshFinished()
        
        XCTAssertTrue(context.newsScene.didHideRefreshIndicator)
    }
    
    func testTellTheSceneToShowTheRefreshIndicatorWhenRefreshBegins() {
        let newsInteractor = FakeNewsInteractor()
        let context = NewsPresenterTestBuilder().with(newsInteractor).build()
        context.simulateNewsSceneDidLoad()
        newsInteractor.simulateRefreshBegan()
        
        XCTAssertTrue(context.newsScene.didShowRefreshIndicator)
    }
    
}
