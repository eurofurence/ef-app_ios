import PreloadComponent
import UIKit.UIViewController

class StubPreloadSceneFactory: PreloadSceneFactory {

    let splashScene = CapturingSplashScene()
    func makePreloadScene() -> UIViewController & SplashScene {
        return splashScene
    }

}

class CapturingSplashScene: UIViewController, SplashScene {

    var delegate: SplashSceneDelegate?

    private(set) var capturedProgress: Float?
    private(set) var capturedProgressDescription: String?
    func showProgress(_ progress: Float, progressDescription: String) {
        capturedProgress = progress
        capturedProgressDescription = progressDescription
    }
    
    private(set) var didShowStaleAppAlert = false
    func showStaleAppAlert() {
        didShowStaleAppAlert = true
    }

    func notifySceneWillAppear() {
        delegate?.splashSceneWillAppear(self)
    }

}

class CapturingSplashSceneDelegate: SplashSceneDelegate {

    private(set) var toldSplashSceneWillAppear = false
    func splashSceneWillAppear(_ splashScene: SplashScene) {
        toldSplashSceneWillAppear = true
    }

}
