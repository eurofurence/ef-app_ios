//
//  RootModuleTestBuilder.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles

class CapturingRootModuleDelegate: RootModuleDelegate {

    private(set) var toldTutorialShouldBePresented = false
    func rootModuleDidDetermineTutorialShouldBePresented() {
        toldTutorialShouldBePresented = true
    }

    private(set) var toldStoreShouldRefresh = false
    func rootModuleDidDetermineStoreShouldRefresh() {
        toldStoreShouldRefresh = true
    }

    private(set) var toldPrincipleModuleShouldBePresented = false
    func rootModuleDidDetermineRootModuleShouldBePresented() {
        toldPrincipleModuleShouldBePresented = true
    }

}

class RootModuleTestBuilder {

    struct Context {
        var delegate: CapturingRootModuleDelegate
    }

    private let app = CapturingEurofurenceSession()
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
