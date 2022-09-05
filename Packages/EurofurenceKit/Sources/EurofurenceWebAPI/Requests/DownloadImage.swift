import Foundation

public struct DownloadImage: Equatable, Hashable, @unchecked Sendable {
    
    public var imageIdentifier: String
    public var lastKnownImageContentHashSHA1: String
    public var downloadDestinationURL: URL
    
    public init(imageIdentifier: String, lastKnownImageContentHashSHA1: String, downloadDestinationURL: URL) {
        self.imageIdentifier = imageIdentifier
        self.lastKnownImageContentHashSHA1 = lastKnownImageContentHashSHA1
        self.downloadDestinationURL = downloadDestinationURL
    }
    
}
