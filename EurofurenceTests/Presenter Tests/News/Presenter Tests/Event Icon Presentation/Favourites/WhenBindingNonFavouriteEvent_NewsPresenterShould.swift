//
//  WhenBindingNonFavouriteEvent_NewsPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 17/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenBindingNonFavouriteEvent_NewsPresenterShould: XCTestCase {

    var viewModel: FavouriteEventNewsViewModel!
    var eventViewModel: EventComponentViewModel!
    var indexPath: IndexPath!
    var newsInteractor: StubNewsInteractor!
    var context: NewsPresenterTestBuilder.Context!

    override func setUp() {
        super.setUp()

        eventViewModel = .random
        eventViewModel.isFavourite = false
        viewModel = FavouriteEventNewsViewModel(eventViewModel: eventViewModel)
        let indexPath = IndexPath(item: 0, section: 0)

        newsInteractor = StubNewsInteractor(viewModel: viewModel)
        context = NewsPresenterTestBuilder().with(newsInteractor).build()
        context.simulateNewsSceneDidLoad()
        context.bindSceneComponent(at: indexPath)
    }

    func testTellTheComponentToHideTheFavouriteIndicator() {
        XCTAssertTrue(context.newsScene.stubbedEventComponent.didHideFavouriteEventIndicator)
    }

    func testNotTellTheComponentToShowTheFavouriteIndicator() {
        XCTAssertFalse(context.newsScene.stubbedEventComponent.didShowFavouriteEventIndicator)
    }

}
