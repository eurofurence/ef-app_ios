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

    private struct FakeDataStoreStateService: SessionStateService {

        var state: EurofurenceSessionState

        func determineSessionState(completionHandler: @escaping (EurofurenceSessionState) -> Void) {
            completionHandler(state)
        }

    }

    private var dataStoreStateService = FakeDataStoreStateService(state: .uninitialized)
    private let delegate = CapturingRootModuleDelegate()
    private var storeState: EurofurenceSessionState = .uninitialized

    @discardableResult
    func with(storeState: EurofurenceSessionState) -> RootModuleTestBuilder {
        dataStoreStateService = FakeDataStoreStateService(state: storeState)
        return self
    }

    func build() -> RootModuleTestBuilder.Context {
        _ = RootModuleBuilder().with(dataStoreStateService).build().makeRootModule(delegate)
        return Context(delegate: delegate)
    }

}
