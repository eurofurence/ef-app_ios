//
//  FakeMapsInteractor.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

struct FakeMapsInteractor: MapsInteractor {
    
    var viewModel: MapsViewModel
    
    init(viewModel: MapsViewModel = FakeMapsViewModel()) {
        self.viewModel = viewModel
    }
    
    func makeMapsViewModel(completionHandler: @escaping (MapsViewModel) -> Void) {
        completionHandler(viewModel)
    }
    
}
