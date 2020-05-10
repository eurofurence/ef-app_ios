class DealersComponentBuilder {

    private var dealersSceneFactory: DealersSceneFactory
    private var dealersViewModelFactory: DealersViewModelFactory

    init(dealersViewModelFactory: DealersViewModelFactory) {
        self.dealersViewModelFactory = dealersViewModelFactory
        dealersSceneFactory = StoryboardDealersSceneFactory()
    }

    @discardableResult
    func with(_ dealersSceneFactory: DealersSceneFactory) -> Self {
        self.dealersSceneFactory = dealersSceneFactory
        return self
    }

    func build() -> DealersComponentFactory {
        DealersComponentFactoryImpl(
            dealersSceneFactory: dealersSceneFactory,
            dealersViewModelFactory: dealersViewModelFactory
        )
    }

}
