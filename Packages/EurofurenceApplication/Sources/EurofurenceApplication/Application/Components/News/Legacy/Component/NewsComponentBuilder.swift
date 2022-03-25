public class NewsComponentBuilder {

    private var newsSceneFactory: NewsSceneFactory
    private let newsViewModelProducer: NewsViewModelProducer

    public init(newsViewModelProduer: NewsViewModelProducer) {
        self.newsViewModelProducer = newsViewModelProduer
        newsSceneFactory = StoryboardNewsSceneFactory()
    }

    public func with(_ newsSceneFactory: NewsSceneFactory) -> Self {
        self.newsSceneFactory = newsSceneFactory
        return self
    }

    public func build() -> NewsComponentFactory {
        NewsComponentFactoryImpl(
            newsSceneFactory: newsSceneFactory,
            newsViewModelProducer: newsViewModelProducer
        )
    }

}
