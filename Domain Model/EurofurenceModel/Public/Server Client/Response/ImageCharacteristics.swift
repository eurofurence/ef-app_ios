import Foundation

public struct ImageCharacteristics: Equatable, Identifyable {

    public var identifier: String
    
    public var internalReference: String
    public var contentHashSha1: String

    public init(identifier: String, internalReference: String, contentHashSha1: String) {
        self.identifier = identifier
        self.internalReference = internalReference
        self.contentHashSha1 = contentHashSha1
    }

}
