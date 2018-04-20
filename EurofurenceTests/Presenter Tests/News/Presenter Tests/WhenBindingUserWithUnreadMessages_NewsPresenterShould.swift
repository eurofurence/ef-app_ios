//
//  WhenBindingUserWithUnreadMessages_NewsPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 20/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenBindingUserWithUnreadMessages_NewsPresenterShould: XCTestCase {
    
    var viewModel: StubbedUserViewModel!
    var userWidgetViewModel: UserWidgetComponentViewModel!
    var indexPath: IndexPath!
    var newsInteractor: StubNewsInteractor!
    var context: NewsPresenterTestBuilder.Context!
    var boundComponent: Any?
    
    override func setUp() {
        super.setUp()
        
        userWidgetViewModel = .random
        userWidgetViewModel.hasUnreadMessages = true
        viewModel = StubbedUserViewModel(viewModel: userWidgetViewModel)
        indexPath = IndexPath(row: 0, section: 0)
        
        newsInteractor = StubNewsInteractor(viewModel: viewModel)
        context = NewsPresenterTestBuilder().with(newsInteractor).build()
        context.simulateNewsSceneWillAppear()
        boundComponent = context.sceneFactory.stubbedScene.bindComponent(at: indexPath)
    }
    
    func testShowTheHighlightedUserPrompt() {
        XCTAssertTrue(context.newsScene.stubbedUserWidgetComponent.didShowHighlightedPrompt)
    }
    
}
