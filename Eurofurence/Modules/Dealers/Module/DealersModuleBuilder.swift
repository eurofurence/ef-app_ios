//
//  DealersModuleBuilder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 23/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

class DealersModuleBuilder {

    private var dealersSceneFactory: DealersSceneFactory
    private var interactor: DealersInteractor

    init() {
        struct DummyDealersInteractor: DealersInteractor {
            func makeDealersViewModel(completionHandler: @escaping (DealersViewModel) -> Void) {

            }
        }

        dealersSceneFactory = StoryboardDealersSceneFactory()
        interactor = DummyDealersInteractor()
    }

    @discardableResult
    func with(_ dealersSceneFactory: DealersSceneFactory) -> DealersModuleBuilder {
        self.dealersSceneFactory = dealersSceneFactory
        return self
    }

    @discardableResult
    func with(_ interactor: DealersInteractor) -> DealersModuleBuilder {
        self.interactor = interactor
        return self
    }

    func build() -> DealersModuleProviding {
        return DealersModule(dealersSceneFactory: dealersSceneFactory, interactor: interactor)
    }

}
