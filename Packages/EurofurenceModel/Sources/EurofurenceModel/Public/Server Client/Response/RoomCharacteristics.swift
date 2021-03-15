import Foundation

public struct RoomCharacteristics: Equatable, Identifyable {

    public var identifier: String
    
    public var name: String

    public init(identifier: String, name: String) {
        self.identifier = identifier
        self.name = name
    }

}
