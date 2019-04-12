import UIKit.UIViewController

struct NewsModule: NewsModuleProviding {

    var newsSceneFactory: NewsSceneFactory
    var newsInteractor: NewsInteractor

    func makeNewsModule(_ delegate: NewsModuleDelegate) -> UIViewController {
        let scene = newsSceneFactory.makeNewsScene()
        _ = NewsPresenter(delegate: delegate,
                          newsScene: scene,
                          newsInteractor: newsInteractor)

        return scene
    }

}
