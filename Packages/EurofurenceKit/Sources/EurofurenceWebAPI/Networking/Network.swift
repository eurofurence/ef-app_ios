import Foundation

/// Describes the protocol to communicate with the networking layer of the platform.
public protocol Network {
    
    /// Asynchronously executes a network request, returning the contents of the payload.
    /// - Parameter request: A `NetworkRequest` designating the resource to load.
    /// - Returns: An unprocessed `Data` reference for ingesting by the caller.
    @discardableResult
    func perform(request: NetworkRequest) async throws -> Data
    
    /// Asynchronously executes a network request, writing the contents of the payload directly to the file system.
    ///
    /// Usage of this methd is preferred over ``Network/perform(request:)`` when it is known the size of the data to
    /// be downloaded will consume a larger amount of memory, to keep the memory footprint of the application low.
    ///
    /// - Parameters:
    ///   - request: A `NetworkRequest` designating the resource to load.
    ///   - destinationURL: The `URL` within the file system the data will be written to. A file must not already exist
    ///                     at the destination prior to calling this method.
    func download(contentsOf request: NetworkRequest, to destinationURL: URL) async throws
    
}
