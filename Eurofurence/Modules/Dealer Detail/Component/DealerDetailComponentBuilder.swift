import Foundation

class DealerDetailComponentBuilder {

    private var dealerDetailSceneFactory: DealerDetailSceneFactory
    private let dealerDetailInteractor: DealerDetailViewModelFactory
    private let dealerInteractionRecorder: DealerInteractionRecorder

    init(dealerDetailInteractor: DealerDetailViewModelFactory, dealerInteractionRecorder: DealerInteractionRecorder) {
        self.dealerDetailInteractor = dealerDetailInteractor
        self.dealerInteractionRecorder = dealerInteractionRecorder
        dealerDetailSceneFactory = StoryboardDealerDetailSceneFactory()
    }

    @discardableResult
    func with(_ dealerDetailSceneFactory: DealerDetailSceneFactory) -> Self {
        self.dealerDetailSceneFactory = dealerDetailSceneFactory
        return self
    }

    func build() -> DealerDetailComponentFactory {
        DealerDetailComponentFactoryImpl(
            dealerDetailSceneFactory: dealerDetailSceneFactory,
            dealerDetailInteractor: dealerDetailInteractor,
            dealerInteractionRecorder: dealerInteractionRecorder
        )
    }

}
