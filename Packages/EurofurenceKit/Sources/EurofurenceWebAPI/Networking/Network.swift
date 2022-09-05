import Foundation

public struct NetworkRequest: Hashable {
    
    public enum Method: Hashable {
        case get
        case post
    }
    
    public var url: URL
    public var body: Data?
    public var method: Method
    
    public init(url: URL, body: Data? = nil, method: NetworkRequest.Method) {
        self.url = url
        self.body = body
        self.method = method
    }
    
}

public protocol Network {
    
    func get(contentsOf url: URL) async throws -> Data
    func download(contentsOf url: URL, to destinationURL: URL) async throws
    
    func perform(request: NetworkRequest) async throws -> Data
    
}
