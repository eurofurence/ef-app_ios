import Foundation

class DealerDetailModuleBuilder {

    private var dealerDetailSceneFactory: DealerDetailSceneFactory
    private let dealerDetailInteractor: DealerDetailInteractor
    private let dealerInteractionRecorder: DealerInteractionRecorder

    init(dealerDetailInteractor: DealerDetailInteractor, dealerInteractionRecorder: DealerInteractionRecorder) {
        self.dealerDetailInteractor = dealerDetailInteractor
        self.dealerInteractionRecorder = dealerInteractionRecorder
        dealerDetailSceneFactory = StoryboardDealerDetailSceneFactory()
    }

    @discardableResult
    func with(_ dealerDetailSceneFactory: DealerDetailSceneFactory) -> DealerDetailModuleBuilder {
        self.dealerDetailSceneFactory = dealerDetailSceneFactory
        return self
    }

    func build() -> DealerDetailModuleProviding {
        return DealerDetailModule(dealerDetailSceneFactory: dealerDetailSceneFactory,
                                  dealerDetailInteractor: dealerDetailInteractor,
                                  dealerInteractionRecorder: dealerInteractionRecorder)
    }

}
