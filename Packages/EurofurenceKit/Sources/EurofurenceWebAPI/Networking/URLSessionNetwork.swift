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
    
    private static let userAgent: String? = {
        return Bundle.main.infoDictionary.flatMap { (info) -> String in
            let executable = info[kCFBundleExecutableKey as String] as? String ?? "Unknown"
            let bundle = info[kCFBundleIdentifierKey as String] as? String ?? "Unknown"
            let appVersion = info["CFBundleShortVersionString"] as? String ?? "Unknown"
            let appBuild = info[kCFBundleVersionKey as String] as? String ?? "Unknown"

            let osNameVersion: String = {
                let version = ProcessInfo.processInfo.operatingSystemVersion
                let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"

                return "iOS \(versionString)"
            }()

            return "\(executable)/\(appVersion) (\(bundle); build:\(appBuild); \(osNameVersion))"
        }
    }()
    
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
        urlRequest.httpBody = request.body
        urlRequest.httpMethod = {
            switch request.method {
            case .post:
                return "POST"
                
            default:
                return "GET"
            }
        }()
        
        urlRequest.setValue(type(of: self).userAgent, forHTTPHeaderField: "User-Agent")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        for (header, value) in request.headers {
            urlRequest.setValue(value, forHTTPHeaderField: header)
        }
        
        return urlRequest
    }
    
}
