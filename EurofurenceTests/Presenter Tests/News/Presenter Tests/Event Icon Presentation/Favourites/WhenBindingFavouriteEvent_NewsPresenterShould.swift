//
//  WhenBindingFavouriteEvent_NewsPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 17/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

struct FavouriteEventNewsViewModel: NewsViewModel {
    
    var eventViewModel: EventComponentViewModel
    
    var numberOfComponents: Int {
        return 1
    }
    
    func numberOfItemsInComponent(at index: Int) -> Int {
        return 1
    }
    
    func titleForComponent(at index: Int) -> String {
        return "Favourite Event"
    }
    
    func describeComponent(at indexPath: IndexPath, to visitor: NewsViewModelVisitor) {
        visitor.visit(eventViewModel)
    }
    
    func fetchModelValue(at indexPath: IndexPath, completionHandler: @escaping (NewsViewModelValue) -> Void) {
        
    }
    
}

class WhenBindingFavouriteEvent_NewsPresenterShould: XCTestCase {
    
    var viewModel: FavouriteEventNewsViewModel!
    var eventViewModel: EventComponentViewModel!
    var indexPath: IndexPath!
    var newsInteractor: StubNewsInteractor!
    var context: NewsPresenterTestBuilder.Context!
    
    override func setUp() {
        super.setUp()
        
        eventViewModel = .random
        eventViewModel.isFavourite = true
        viewModel = FavouriteEventNewsViewModel(eventViewModel: eventViewModel)
        let indexPath = IndexPath(item: 0, section: 0)
        
        newsInteractor = StubNewsInteractor(viewModel: viewModel)
        context = NewsPresenterTestBuilder().with(newsInteractor).build()
        context.simulateNewsSceneDidLoad()
        context.bindSceneComponent(at: indexPath)
    }
    
    func testShowTheFavouriteIndicator() {
        XCTAssertTrue(context.newsScene.stubbedEventComponent.didShowFavouriteEventIndicator)
    }
    
    func testNotHideTheFavouriteIndicator() {
        XCTAssertFalse(context.newsScene.stubbedEventComponent.didHideFavouriteEventIndicator)
    }
    
}
