import Foundation

public protocol MapsScene {

    func setDelegate(_ delegate: MapsSceneDelegate)
    func setMapsTitle(_ title: String)
    func bind(numberOfMaps: Int, using binder: MapsBinder)

}

public protocol MapsSceneDelegate {

    func mapsSceneDidLoad()
    func simulateSceneDidSelectMap(at index: Int)

}
