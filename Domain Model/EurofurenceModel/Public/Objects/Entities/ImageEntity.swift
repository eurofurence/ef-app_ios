import Foundation

public class ImageEntity: Equatable {

    public static func == (lhs: ImageEntity, rhs: ImageEntity) -> Bool {
        return lhs.identifier == rhs.identifier &&
               lhs.pngImageData == rhs.pngImageData
    }

    public var identifier: String
    public var pngImageData: Data

    public init(identifier: String, pngImageData: Data) {
        self.identifier = identifier
        self.pngImageData = pngImageData
    }

}
