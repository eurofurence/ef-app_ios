//
//  WhenBindingUser_NewsPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 20/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class StubbedUserViewModel: NewsViewModel {
    
    let userWidgetViewModel = UserWidgetComponentViewModel.random
    
    var numberOfComponents: Int {
        return 1
    }
    
    func numberOfItemsInComponent(at index: Int) -> Int {
        return 1
    }
    
    func titleForComponent(at index: Int) -> String {
        return ""
    }
    
    func describeComponent(at indexPath: IndexPath, to visitor: NewsViewModelVisitor) {
        visitor.visit(userWidgetViewModel)
    }
    
    
}

class WhenBindingUser_NewsPresenterShould: XCTestCase {
    
    var viewModel: StubbedUserViewModel!
    var userWidgetViewModel: UserWidgetComponentViewModel!
    var indexPath: IndexPath!
    var newsInteractor: StubNewsInteractor!
    var context: NewsPresenterTestBuilder.Context!
    var boundComponent: Any?
    
    override func setUp() {
        super.setUp()
        
        viewModel = StubbedUserViewModel()
        userWidgetViewModel = viewModel.userWidgetViewModel
        indexPath = IndexPath(row: 0, section: 0)
        
        newsInteractor = StubNewsInteractor(viewModel: viewModel)
        context = NewsPresenterTestBuilder().with(newsInteractor).build()
        context.simulateNewsSceneWillAppear()
        boundComponent = context.sceneFactory.stubbedScene.bindComponent(at: indexPath)
    }
    
    func testSetThePromptOntoTheUserWidgetComponent() {
        XCTAssertEqual(userWidgetViewModel.prompt, context.newsScene.stubbedUserWidgetComponent.capturedPrompt)
    }
    
    func testSetTheDetailedPromptOntoTheUserWidgetComponent() {
        XCTAssertEqual(userWidgetViewModel.detailedPrompt, context.newsScene.stubbedUserWidgetComponent.capturedDetailedPrompt)
    }
    
}
