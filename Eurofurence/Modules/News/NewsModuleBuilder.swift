class NewsModuleBuilder {

    private var newsSceneFactory: NewsSceneFactory
    private var newsInteractor: NewsInteractor

    init() {
        newsSceneFactory = StoryboardNewsSceneFactory()
        newsInteractor = DefaultNewsInteractor()
    }

    func with(_ newsSceneFactory: NewsSceneFactory) -> NewsModuleBuilder {
        self.newsSceneFactory = newsSceneFactory
        return self
    }

    func with(_ newsInteractor: NewsInteractor) -> NewsModuleBuilder {
        self.newsInteractor = newsInteractor
        return self
    }

    func build() -> NewsModuleProviding {
        return NewsModule(newsSceneFactory: newsSceneFactory, newsInteractor: newsInteractor)
    }

}
