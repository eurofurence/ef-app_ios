//
//  RootModuleTestBuilder.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence

class RootModuleTestBuilder {
    
    struct Context {
        var delegate: CapturingRootModuleDelegate
    }
    
    private let app = CapturingEurofurenceApplication()
    private let delegate = CapturingRootModuleDelegate()
    private var storeState: EurofurenceDataStoreState = .absent
    
    @discardableResult
    func with(storeState: EurofurenceDataStoreState) -> RootModuleTestBuilder {
        self.storeState = storeState
        return self
    }
    
    func build() -> RootModuleTestBuilder.Context {
        _ = RootModuleBuilder().with(app).build().makeRootModule(delegate)
        app.capturedStoreStateResolutionHandler?(storeState)
        
        return Context(delegate: delegate)
    }
    
}
