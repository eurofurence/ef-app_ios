import Foundation

public struct DownloadImageRequest: Equatable, Hashable {
    
    var imageIdentifier: String
    var lastKnownImageContentHashSHA1: String
    var downloadDestinationURL: URL
    
    public init(imageIdentifier: String, lastKnownImageContentHashSHA1: String, downloadDestinationURL: URL) {
        self.imageIdentifier = imageIdentifier
        self.lastKnownImageContentHashSHA1 = lastKnownImageContentHashSHA1
        self.downloadDestinationURL = downloadDestinationURL
    }
    
}
