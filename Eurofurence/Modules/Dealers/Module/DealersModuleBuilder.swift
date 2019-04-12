class DealersModuleBuilder {

    private var dealersSceneFactory: DealersSceneFactory
    private var interactor: DealersInteractor

    init() {
        dealersSceneFactory = StoryboardDealersSceneFactory()
        interactor = DefaultDealersInteractor()
    }

    @discardableResult
    func with(_ dealersSceneFactory: DealersSceneFactory) -> DealersModuleBuilder {
        self.dealersSceneFactory = dealersSceneFactory
        return self
    }

    @discardableResult
    func with(_ interactor: DealersInteractor) -> DealersModuleBuilder {
        self.interactor = interactor
        return self
    }

    func build() -> DealersModuleProviding {
        return DealersModule(dealersSceneFactory: dealersSceneFactory, interactor: interactor)
    }

}
