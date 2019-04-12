import Foundation

protocol CollectThemAllScene {

    func setDelegate(_ delegate: CollectThemAllSceneDelegate)
    func setShortCollectThemAllTitle(_ shortTitle: String)
    func setCollectThemAllTitle(_ title: String)
    func loadGame(at urlRequest: URLRequest)

}

protocol CollectThemAllSceneDelegate {

    func collectThemAllSceneDidLoad()

}
