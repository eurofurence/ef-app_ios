import Foundation

class DealerDetailComponentBuilder {

    private var dealerDetailSceneFactory: DealerDetailSceneFactory
    private let dealerDetailViewModelFactory: DealerDetailViewModelFactory
    private let dealerInteractionRecorder: DealerInteractionRecorder

    init(
        dealerDetailViewModelFactory: DealerDetailViewModelFactory,
        dealerInteractionRecorder: DealerInteractionRecorder
    ) {
        self.dealerDetailViewModelFactory = dealerDetailViewModelFactory
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
            dealerDetailViewModelFactory: dealerDetailViewModelFactory,
            dealerInteractionRecorder: dealerInteractionRecorder
        )
    }

}
