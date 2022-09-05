import Foundation

struct URLSessionNetwork: Network {
    
    static let shared = URLSessionNetwork()
    
    private let urlSession: URLSession
    
    private init() {
        let delegateQueue = OperationQueue()
        delegateQueue.name = "EurofurenceKit Network"
        delegateQueue.qualityOfService = .utility
        
        urlSession = URLSession(configuration: .default, delegate: nil, delegateQueue: delegateQueue)
    }
    
    func perform(request: NetworkRequest) async throws -> Data {
        let urlRequest = prepareSessionRequest(from: request)
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Data, Error>) in
            let dataTask = urlSession.dataTask(with: urlRequest) { data, _, error in
                if let data = data {
                    continuation.resume(returning: data)
                }
                
                if let error = error {
                    continuation.resume(throwing: error)
                }
            }
            
            dataTask.resume()
        }
    }
    
    func download(contentsOf request: NetworkRequest, to destinationURL: URL) async throws {
        let urlRequest = prepareSessionRequest(from: request)
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            let downloadTask = urlSession.downloadTask(with: urlRequest) { url, _, error in
                if let url = url {
                    // Move the temporary file created by NSURLSession to the destination URL.
                    // The transient URL will not be available by the time this completion handler returns.
                    let fileManager = FileManager.default
                    do {
                        try fileManager.moveItem(at: url, to: destinationURL)
                        continuation.resume()
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
                
                if let error = error {
                    continuation.resume(throwing: error)
                }
            }
            
            downloadTask.resume()
        }
    }
    
    private func prepareSessionRequest(from request: NetworkRequest) -> URLRequest {
        var urlRequest = URLRequest(url: request.url)
        urlRequest.httpMethod = {
            switch request.method {
            case .post:
                return "POST"
                
            default:
                return "GET"
            }
        }()
        
        return urlRequest
    }
    
}
