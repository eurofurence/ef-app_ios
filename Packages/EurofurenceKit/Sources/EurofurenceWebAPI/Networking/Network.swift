import Foundation

public protocol Network {
    
    func get(contentsOf url: URL) async throws -> Data
    
}
