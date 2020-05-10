class NewsComponentBuilder {

    private var newsSceneFactory: NewsSceneFactory
    private let newsViewModelProducer: NewsViewModelProducer

    init(newsViewModelProduer: NewsViewModelProducer) {
        self.newsViewModelProducer = newsViewModelProduer
        newsSceneFactory = StoryboardNewsSceneFactory()
    }

    func with(_ newsSceneFactory: NewsSceneFactory) -> Self {
        self.newsSceneFactory = newsSceneFactory
        return self
    }

    func build() -> NewsComponentFactory {
        NewsComponentFactoryImpl(
            newsSceneFactory: newsSceneFactory,
            newsViewModelProducer: newsViewModelProducer
        )
    }

}
