//
//  WhenBindingAboutTheArtComponent_DealerDetailPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenBindingAboutTheArtComponent_DealerDetailPresenterShould: XCTestCase {
    
    func testBindTheTitleOntoTheComponent() {
        let aboutTheArtViewModel = DealerDetailAboutTheArtViewModel.random
        let viewModel = FakeDealerDetailAboutTheArtViewModel(aboutTheArt: aboutTheArtViewModel)
        let interactor = FakeDealerDetailInteractor(viewModel: viewModel)
        let context = DealerDetailPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        context.bindComponent(at: 0)
        
        XCTAssertEqual(aboutTheArtViewModel.title, context.boundAboutTheArtComponent?.capturedTitle)
    }
    
    func testBindTheArtDescriptionOntoTheComponent() {
        let aboutTheArtViewModel = DealerDetailAboutTheArtViewModel.random
        let viewModel = FakeDealerDetailAboutTheArtViewModel(aboutTheArt: aboutTheArtViewModel)
        let interactor = FakeDealerDetailInteractor(viewModel: viewModel)
        let context = DealerDetailPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        context.bindComponent(at: 0)
        
        XCTAssertEqual(aboutTheArtViewModel.aboutTheArt, context.boundAboutTheArtComponent?.capturedAboutTheArt)
    }
    
}
