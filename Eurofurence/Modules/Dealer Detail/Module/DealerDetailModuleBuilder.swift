import Foundation

class DealerDetailModuleBuilder {

    private var dealerDetailSceneFactory: DealerDetailSceneFactory
    private let dealerDetailInteractor: DealerDetailInteractor

    init(dealerDetailInteractor: DealerDetailInteractor) {
        self.dealerDetailInteractor = dealerDetailInteractor
        dealerDetailSceneFactory = StoryboardDealerDetailSceneFactory()
    }

    @discardableResult
    func with(_ dealerDetailSceneFactory: DealerDetailSceneFactory) -> DealerDetailModuleBuilder {
        self.dealerDetailSceneFactory = dealerDetailSceneFactory
        return self
    }

    func build() -> DealerDetailModuleProviding {
        return DealerDetailModule(dealerDetailSceneFactory: dealerDetailSceneFactory,
                                  dealerDetailInteractor: dealerDetailInteractor)
    }

}
