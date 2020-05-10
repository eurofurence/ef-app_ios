class DealersComponentBuilder {

    private var dealersSceneFactory: DealersSceneFactory
    private var interactor: DealersViewModelFactory

    init(interactor: DealersViewModelFactory) {
        self.interactor = interactor
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
            interactor: interactor
        )
    }

}
