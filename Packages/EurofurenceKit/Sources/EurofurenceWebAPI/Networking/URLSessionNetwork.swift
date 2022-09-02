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
    
    func get(contentsOf url: URL) async throws -> Data {
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Data, Error>) in
            let urlRequest = URLRequest(url: url)
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
    
    func download(contentsOf url: URL) async throws -> URL {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<URL, Error>) in
            let urlRequest = URLRequest(url: url)
            let downloadTask = urlSession.downloadTask(with: urlRequest) { url, _, error in
                if let url = url {
                    continuation.resume(returning: url)
                }
                
                if let error = error {
                    continuation.resume(throwing: error)
                }
            }
            
            downloadTask.resume()
        }
    }
    
}
