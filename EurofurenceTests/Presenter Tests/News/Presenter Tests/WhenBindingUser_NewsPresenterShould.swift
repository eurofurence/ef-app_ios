//
//  WhenBindingUser_NewsPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 20/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class StubbedUserViewModel: NewsViewModel {
    
    let userWidgetViewModel: UserWidgetComponentViewModel
    
    init(viewModel: UserWidgetComponentViewModel = .random) {
        self.userWidgetViewModel = viewModel
    }
    
    var numberOfComponents: Int {
        return 1
    }
    
    func numberOfItemsInComponent(at index: Int) -> Int {
        return 1
    }
    
    func titleForComponent(at index: Int) -> String {
        return "User Widget"
    }
    
    func describeComponent(at indexPath: IndexPath, to visitor: NewsViewModelVisitor) {
        visitor.visit(userWidgetViewModel)
    }
    
    func fetchModelValue(at indexPath: IndexPath, completionHandler: @escaping (NewsViewModelValue) -> Void) {
        completionHandler(.messages)
    }
    
}

class WhenBindingUser_NewsPresenterShould: XCTestCase {
    
    var viewModel: StubbedUserViewModel!
    var userWidgetViewModel: UserWidgetComponentViewModel!
    var indexPath: IndexPath!
    var newsInteractor: StubNewsInteractor!
    var context: NewsPresenterTestBuilder.Context!
    
    override func setUp() {
        super.setUp()
        
        viewModel = StubbedUserViewModel()
        userWidgetViewModel = viewModel.userWidgetViewModel
        indexPath = IndexPath(row: 0, section: 0)
        
        newsInteractor = StubNewsInteractor(viewModel: viewModel)
        context = NewsPresenterTestBuilder().with(newsInteractor).build()
        context.simulateNewsSceneDidLoad()
        context.bindSceneComponent(at: indexPath)
    }
    
    func testSetThePromptOntoTheUserWidgetComponent() {
        XCTAssertEqual(userWidgetViewModel.prompt, context.newsScene.stubbedUserWidgetComponent.capturedPrompt)
    }
    
    func testSetTheDetailedPromptOntoTheUserWidgetComponent() {
        XCTAssertEqual(userWidgetViewModel.detailedPrompt, context.newsScene.stubbedUserWidgetComponent.capturedDetailedPrompt)
    }
    
    func testTellTheModuleDelegateToShowPrivateMessagesWhenSceneSelectsMessagesComponent() {
        context.selectComponent(at: indexPath)
        XCTAssertTrue(context.delegate.showPrivateMessagesRequested)
    }
    
}
