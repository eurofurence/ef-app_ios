class NewsComponentBuilder {

    private var newsSceneFactory: NewsSceneFactory
    private let newsInteractor: NewsViewModelProducer

    init(newsInteractor: NewsViewModelProducer) {
        self.newsInteractor = newsInteractor
        newsSceneFactory = StoryboardNewsSceneFactory()
    }

    func with(_ newsSceneFactory: NewsSceneFactory) -> Self {
        self.newsSceneFactory = newsSceneFactory
        return self
    }

    func build() -> NewsComponentFactory {
        NewsComponentFactoryImpl(
            newsSceneFactory: newsSceneFactory,
            newsInteractor: newsInteractor
        )
    }

}
