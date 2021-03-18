import Foundation

public protocol SplashScene: class {

    var delegate: SplashSceneDelegate? { get set }

    func showProgress(_ progress: Float, progressDescription: String)
    func showStaleAppAlert()

}

public protocol SplashSceneDelegate {

    func splashSceneWillAppear(_ splashScene: SplashScene)

}
