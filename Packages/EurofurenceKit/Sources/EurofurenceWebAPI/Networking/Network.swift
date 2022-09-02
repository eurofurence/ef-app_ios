import Foundation

public protocol Network {
    
    func get(contentsOf url: URL) async throws -> Data
    func download(contentsOf url: URL, to destinationURL: URL) async throws
    
}