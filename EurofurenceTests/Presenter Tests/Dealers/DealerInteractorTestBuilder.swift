//
//  DealerInteractorTestBuilder.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 01/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class DealerInteractorTestBuilder {
    
    struct Context {
        var interactor: DefaultDealersInteractor
        var dealersService: FakeDealersService
        var defaultIconData: Data
        var refreshService: CapturingRefreshService
    }
    
    private var dealersService: FakeDealersService
    private var defaultIconData: Data
    
    init() {
        dealersService = FakeDealersService()
        defaultIconData = Data()
    }
    
    @discardableResult
    func with(_ dealersService: FakeDealersService) -> DealerInteractorTestBuilder {
        self.dealersService = dealersService
        return self
    }
    
    @discardableResult
    func with(_ defaultIconData: Data) -> DealerInteractorTestBuilder {
        self.defaultIconData = defaultIconData
        return self
    }
    
    func build() -> Context {
        let refreshService = CapturingRefreshService()
        let interactor = DefaultDealersInteractor(dealersService: dealersService,
                                                  defaultIconData: defaultIconData,
                                                  refreshService: refreshService)
        
        return Context(interactor: interactor,
                       dealersService: dealersService,
                       defaultIconData: defaultIconData,
                       refreshService: refreshService)
    }
    
}

extension DealerInteractorTestBuilder.Context {
    
    @discardableResult
    func prepareViewModel() -> DealersViewModel? {
        var viewModel: DealersViewModel?
        interactor.makeDealersViewModel { viewModel = $0 }
        
        return viewModel
    }
    
}
