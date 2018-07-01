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
        let interactor = DefaultDealersInteractor(dealersService: dealersService,
                                                  defaultIconData: defaultIconData)
        
        return Context(interactor: interactor,
                       dealersService: dealersService,
                       defaultIconData: defaultIconData)
    }
    
}
