import UIKit.UIViewController

struct NewsComponentFactoryImpl: NewsComponentFactory {

    var newsSceneFactory: NewsSceneFactory
    var newsInteractor: NewsViewModelProducer

    func makeNewsComponent(_ delegate: NewsComponentDelegate) -> UIViewController {
        let scene = newsSceneFactory.makeNewsScene()
        _ = NewsPresenter(
            delegate: delegate,
            newsScene: scene,
            newsInteractor: newsInteractor
        )

        return scene
    }

}
