import Foundation

public protocol MapDetailScene: AnyObject {

    func setDelegate(_ delegate: MapDetailSceneDelegate)
    func setMapImagePNGData(_ data: Data)
    func setMapTitle(_ title: String)
    func focusMapPosition(_ position: MapCoordinate)
    func show(contextualContent: MapInformationContextualContent)
    func showMapOptions(heading: String,
                        options: [String],
                        atX x: Float,
                        y: Float,
                        selectionHandler: @escaping (Int) -> Void)

}

public protocol MapDetailSceneDelegate {

    func mapDetailSceneDidLoad()
    func mapDetailSceneDidTapMap(at position: MapCoordinate)

}

public struct MapCoordinate: Equatable {
    
    public var x: Float
    public var y: Float
    
    public init(x: Float, y: Float) {
        self.x = x
        self.y = y
    }
    
}

public struct MapInformationContextualContent: Equatable {
    
    public var coordinate: MapCoordinate
    public var content: String
    
    public init(coordinate: MapCoordinate, content: String) {
        self.coordinate = coordinate
        self.content = content
    }
    
}

public protocol MapContentOptionsViewModel {

    var optionsHeading: String { get }
    var options: [String] { get }

    func selectOption(at index: Int)

}
