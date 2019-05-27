class NewsModuleBuilder {

    private var newsSceneFactory: NewsSceneFactory
    private let newsInteractor: NewsInteractor

    init(newsInteractor: NewsInteractor) {
        self.newsInteractor = newsInteractor
        newsSceneFactory = StoryboardNewsSceneFactory()
    }

    func with(_ newsSceneFactory: NewsSceneFactory) -> NewsModuleBuilder {
        self.newsSceneFactory = newsSceneFactory
        return self
    }

    func build() -> NewsModuleProviding {
        return NewsModule(newsSceneFactory: newsSceneFactory, newsInteractor: newsInteractor)
    }

}
