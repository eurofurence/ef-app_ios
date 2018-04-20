//
//  StubNewsInteractor.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 16/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence

struct StubNewsInteractor: NewsInteractor {
    
    var viewModel: NewsViewModel
    
    func subscribeViewModelUpdates(_ delegate: NewsInteractorDelegate) {
        delegate.viewModelDidUpdate(viewModel)
    }
    
}
