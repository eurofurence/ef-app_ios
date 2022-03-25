import UIKit.UIViewController

struct NewsComponentFactoryImpl: NewsComponentFactory {

    var newsSceneFactory: NewsSceneFactory
    var newsViewModelProducer: NewsViewModelProducer

    func makeNewsComponent(_ delegate: NewsComponentDelegate) -> UIViewController {
        let scene = newsSceneFactory.makeNewsScene()
        _ = NewsPresenter(
            delegate: delegate,
            newsScene: scene,
            newsViewModelProducer: newsViewModelProducer
        )

        return scene
    }

}
