import Foundation

public class DealerDetailComponentBuilder {

    private var dealerDetailSceneFactory: DealerDetailSceneFactory
    private let dealerDetailViewModelFactory: DealerDetailViewModelFactory
    private let dealerInteractionRecorder: DealerInteractionRecorder

    public init(
        dealerDetailViewModelFactory: DealerDetailViewModelFactory,
        dealerInteractionRecorder: DealerInteractionRecorder
    ) {
        self.dealerDetailViewModelFactory = dealerDetailViewModelFactory
        self.dealerInteractionRecorder = dealerInteractionRecorder
        dealerDetailSceneFactory = StoryboardDealerDetailSceneFactory()
    }

    @discardableResult
    public func with(_ dealerDetailSceneFactory: DealerDetailSceneFactory) -> Self {
        self.dealerDetailSceneFactory = dealerDetailSceneFactory
        return self
    }

    public func build() -> DealerDetailComponentFactory {
        DealerDetailComponentFactoryImpl(
            dealerDetailSceneFactory: dealerDetailSceneFactory,
            dealerDetailViewModelFactory: dealerDetailViewModelFactory,
            dealerInteractionRecorder: dealerInteractionRecorder
        )
    }

}
