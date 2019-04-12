import Foundation

class DealerDetailModuleBuilder {

    private var dealerDetailSceneFactory: DealerDetailSceneFactory
    private var dealerDetailInteractor: DealerDetailInteractor

    init() {
        dealerDetailSceneFactory = StoryboardDealerDetailSceneFactory()
        dealerDetailInteractor = DefaultDealerDetailInteractor()
    }

    @discardableResult
    func with(_ dealerDetailSceneFactory: DealerDetailSceneFactory) -> DealerDetailModuleBuilder {
        self.dealerDetailSceneFactory = dealerDetailSceneFactory
        return self
    }

    @discardableResult
    func with(_ dealerDetailInteractor: DealerDetailInteractor) -> DealerDetailModuleBuilder {
        self.dealerDetailInteractor = dealerDetailInteractor
        return self
    }

    func build() -> DealerDetailModuleProviding {
        return DealerDetailModule(dealerDetailSceneFactory: dealerDetailSceneFactory,
                                  dealerDetailInteractor: dealerDetailInteractor)
    }

}
