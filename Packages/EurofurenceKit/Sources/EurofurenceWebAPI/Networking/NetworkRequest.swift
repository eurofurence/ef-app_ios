import Foundation

/// Represents the configuration of a request to be submitted to the `Network`.
public struct NetworkRequest: Hashable {
    
    /// The HTTP method to use, as designated by RFC 7231.
    public enum Method: Hashable {
        
        /// HTTP GET
        case get
        
        /// HTTP POST
        case post
        
    }
    
    /// The location of the resource to be fetched over the network.
    public var url: URL
    
    /// The contents of the body to be sent when requesting the `url`.
    public var body: Data?
    
    /// The HTTP method to apply when requesting the resource.
    public var method: Method
    
    public init(url: URL, body: Data? = nil, method: NetworkRequest.Method) {
        self.url = url
        self.body = body
        self.method = method
    }
    
}

// MARK: CustomStringConvertible

extension NetworkRequest.Method: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .get:
            return "GET"
            
        case .post:
            return "POST"
        }
    }
    
}

extension NetworkRequest: CustomStringConvertible {
    
    public var description: String {
        let bodyDescription: String = {
            if let body = body {
                return " (body: \(body.count) bytes)"
            } else {
                return ""
            }
        }()
        
        return "\(method.description) \(url)\(bodyDescription)"
    }
    
}
