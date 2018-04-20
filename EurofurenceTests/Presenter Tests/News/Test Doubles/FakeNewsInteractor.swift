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
    
    var lastCreatedViewModel: StubNewsViewModel = .random
    private(set) var didPrepareViewModel = false
    func prepareViewModel(_ delegate: NewsInteractorDelegate) {
        didPrepareViewModel = true
        let viewModel = StubNewsViewModel.random
        lastCreatedViewModel = viewModel
        delegate.viewModelDidUpdate(viewModel)
    }
    
}
