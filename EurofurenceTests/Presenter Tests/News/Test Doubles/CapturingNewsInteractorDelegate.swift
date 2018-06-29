//
//  CapturingNewsInteractorDelegate.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 23/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation.NSIndexPath

class CapturingNewsInteractorDelegate: NewsInteractorDelegate {
    
    private(set) var viewModel: NewsViewModel?
    func viewModelDidUpdate(_ viewModel: NewsViewModel) {
        self.viewModel = viewModel
    }
    
    private(set) var toldRefreshDidBegin = false
    func refreshDidBegin() {
        toldRefreshDidBegin = true
    }
    
    private(set) var toldRefreshDidFinish = false
    func refreshDidFinish() {
        toldRefreshDidFinish = true
    }
    
}
