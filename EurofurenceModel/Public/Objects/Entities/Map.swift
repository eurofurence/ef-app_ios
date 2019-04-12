import Foundation

public typealias MapIdentifier = Identifier<Map>

public protocol Map {

    var identifier: MapIdentifier { get }
    var location: String { get }
    
    func fetchImagePNGData(completionHandler: @escaping (Data) -> Void)
    func fetchContentAt(x: Int, y: Int, completionHandler: @escaping (MapContent) -> Void)

}
