import Foundation

extension APIRequests {
    
    /// A request to download the contents of an image from the API into a known location within the file system.
    public struct DownloadImage: @unchecked Sendable, APIRequest {
        
        public typealias Output = Void
        
        /// The identifier of the image from the remote to be downloaded.
        public var imageIdentifier: String
        
        /// The last known hashed contents of the image, used for cache-busting within the API.
        public var lastKnownImageContentHashSHA1: String
        
        /// A destination file to write the contents of the image to.
        ///
        /// To avoid the overhead of bringing lots of data into the application's process, the image will be directly
        /// written to the known location on disk. The application may then later fetch the contents of the image for
        /// processing.
        ///
        /// - Important: If another file already exists at this location, it will be overwritten.
        public var downloadDestinationURL: URL
        
        public init(imageIdentifier: String, lastKnownImageContentHashSHA1: String, downloadDestinationURL: URL) {
            self.imageIdentifier = imageIdentifier
            self.lastKnownImageContentHashSHA1 = lastKnownImageContentHashSHA1
            self.downloadDestinationURL = downloadDestinationURL
        }
        
    }
    
}
