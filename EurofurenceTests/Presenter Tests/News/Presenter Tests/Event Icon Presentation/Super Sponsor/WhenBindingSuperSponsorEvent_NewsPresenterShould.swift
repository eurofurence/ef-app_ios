//
//  WhenBindingSuperSponsorEvent_NewsPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 02/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenBindingSuperSponsorEvent_NewsPresenterShould: XCTestCase {
    
    func testShowTheSuperSponsorOnlyIndicator() {
        var eventViewModel: EventComponentViewModel = .random
        eventViewModel.isSuperSponsorEvent = true
        let viewModel = SingleEventNewsViewModel(event: eventViewModel)
        let indexPath = IndexPath(item: 0, section: 0)
        let newsInteractor = StubNewsInteractor(viewModel: viewModel)
        let context = NewsPresenterTestBuilder().with(newsInteractor).build()
        context.simulateNewsSceneDidLoad()
        context.bindSceneComponent(at: indexPath)
        
        XCTAssertTrue(context.newsScene.stubbedEventComponent.didShowSuperSponsorIndicator)
    }
    
    func testNotHideTheSuperSponsorOnlyIndicator() {
        var eventViewModel: EventComponentViewModel = .random
        eventViewModel.isSuperSponsorEvent = true
        let viewModel = SingleEventNewsViewModel(event: eventViewModel)
        let indexPath = IndexPath(item: 0, section: 0)
        let newsInteractor = StubNewsInteractor(viewModel: viewModel)
        let context = NewsPresenterTestBuilder().with(newsInteractor).build()
        context.simulateNewsSceneDidLoad()
        context.bindSceneComponent(at: indexPath)
        
        XCTAssertFalse(context.newsScene.stubbedEventComponent.didHideSuperSponsorIndicator)
    }
    
}
