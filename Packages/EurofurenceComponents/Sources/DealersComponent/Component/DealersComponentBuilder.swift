public class DealersComponentBuilder {

    private var dealersSceneFactory: DealersSceneFactory
    private var dealersViewModelFactory: DealersViewModelFactory

    public init(dealersViewModelFactory: DealersViewModelFactory) {
        self.dealersViewModelFactory = dealersViewModelFactory
        dealersSceneFactory = StoryboardDealersSceneFactory()
    }

    @discardableResult
    public func with(_ dealersSceneFactory: DealersSceneFactory) -> Self {
        self.dealersSceneFactory = dealersSceneFactory
        return self
    }

    public func build() -> DealersComponentFactory {
        DealersComponentFactoryImpl(
            dealersSceneFactory: dealersSceneFactory,
            dealersViewModelFactory: dealersViewModelFactory
        )
    }

}
