class DealersModuleBuilder {

    private var dealersSceneFactory: DealersSceneFactory
    private var interactor: DealersInteractor

    init(interactor: DealersInteractor) {
        self.interactor = interactor
        dealersSceneFactory = StoryboardDealersSceneFactory()
    }

    @discardableResult
    func with(_ dealersSceneFactory: DealersSceneFactory) -> DealersModuleBuilder {
        self.dealersSceneFactory = dealersSceneFactory
        return self
    }

    func build() -> DealersModuleProviding {
        return DealersModule(dealersSceneFactory: dealersSceneFactory, interactor: interactor)
    }

}
