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
    
    var lastCreatedViewModel: NewsViewModel = .random
    private(set) var didPrepareViewModel = false
    func prepareViewModel(_ completionHandler: @escaping (NewsViewModel) -> Void) {
        didPrepareViewModel = true
        let viewModel = NewsViewModel.random
        lastCreatedViewModel = viewModel
        completionHandler(viewModel)
    }
    
}
