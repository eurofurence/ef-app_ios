import Foundation

public struct TrackCharacteristics: Equatable, Identifyable {

    public var identifier: String
    
    public var name: String

    public init(identifier: String, name: String) {
        self.identifier = identifier
        self.name = name
    }

}
