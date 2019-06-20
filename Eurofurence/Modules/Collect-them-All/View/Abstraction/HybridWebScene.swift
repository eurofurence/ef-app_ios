import Foundation

protocol HybridWebScene {

    func setDelegate(_ delegate: HybridWebSceneDelegate)
    func setSceneShortTitle(_ shortTitle: String)
    func setSceneTitle(_ title: String)
    func loadContents(of urlRequest: URLRequest)

}

protocol HybridWebSceneDelegate {

    func hybridWebSceneDidLoad()

}
