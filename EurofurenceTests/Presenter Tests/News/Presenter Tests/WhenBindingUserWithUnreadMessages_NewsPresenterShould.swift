//
//  WhenBindingUserWithUnreadMessages_NewsPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 20/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class WhenBindingUserWithUnreadMessages_NewsPresenterShould: XCTestCase {

    var viewModel: StubbedUserViewModel!
    var userWidgetViewModel: UserWidgetComponentViewModel!
    var indexPath: IndexPath!
    var newsInteractor: StubNewsInteractor!
    var context: NewsPresenterTestBuilder.Context!

    override func setUp() {
        super.setUp()

        userWidgetViewModel = .random
        userWidgetViewModel.hasUnreadMessages = true
        viewModel = StubbedUserViewModel(viewModel: userWidgetViewModel)
        indexPath = IndexPath(row: 0, section: 0)

        newsInteractor = StubNewsInteractor(viewModel: viewModel)
        context = NewsPresenterTestBuilder().with(newsInteractor).build()
        context.simulateNewsSceneDidLoad()
        context.bindSceneComponent(at: indexPath)
    }

    func testShowTheHighlightedUserPrompt() {
        XCTAssertTrue(context.newsScene.stubbedUserWidgetComponent.didShowHighlightedPrompt)
    }

    func testNotShowTheDefaultUserPrompt() {
        XCTAssertFalse(context.newsScene.stubbedUserWidgetComponent.didShowStandardPrompt)
    }

    func testNotHideTheHighlightedUserPrompt() {
        XCTAssertFalse(context.newsScene.stubbedUserWidgetComponent.didHideHighlightedPrompt)
    }

    func testHideTheDefaultUserPrompt() {
        XCTAssertTrue(context.newsScene.stubbedUserWidgetComponent.didHideStandardPrompt)
    }

}
