//
//  WhenScheduleSceneSelectsFavouritesOption_SchedulePresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 04/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenScheduleSceneSelectsFavouritesOption_SchedulePresenterShould: XCTestCase {
    
    func testTellTheViewModelToOnlyShowFavourites() {
        let viewModel = CapturingScheduleViewModel.random
        let interactor = FakeScheduleInteractor(viewModel: viewModel)
        let context = SchedulePresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        context.simulateSceneDidSelectFavouritesOnlyOption()
        
        XCTAssertTrue(viewModel.toldToFilterToFavouritesOnly)
    }
    
}
