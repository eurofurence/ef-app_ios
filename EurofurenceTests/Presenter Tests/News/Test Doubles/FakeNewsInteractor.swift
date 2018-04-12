//
//  FakeNewsInteractor.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 12/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class FakeNewsInteractor: NewsInteractor {
    
    var lastCreatedViewModel: NewsViewModel?
    func prepareViewModel(_ completionHandler: @escaping (NewsViewModel) -> Void) {
        let viewModel = NewsViewModel.random
        lastCreatedViewModel = viewModel
        completionHandler(viewModel)
    }
    
}
