import Foundation

public struct URLSessionBasedJSONSession: JSONSession {

    public static let shared = URLSessionBasedJSONSession()

    private let session: URLSession

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

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func get(_ request: JSONRequest, completionHandler: @escaping (Data?, Error?) -> Void) {
        perform(request, method: "GET", completionHandler: completionHandler)
    }

    public func post(_ request: JSONRequest, completionHandler: @escaping (Data?, Error?) -> Void) {
        perform(request, method: "POST", completionHandler: completionHandler)
    }

    private func perform(_ request: JSONRequest, method: String, completionHandler: @escaping (Data?, Error?) -> Void) {
        guard let actualURL = URL(string: request.url) else { return }

        var urlRequest = URLRequest(url: actualURL)
        urlRequest.setValue(type(of: self).userAgent, forHTTPHeaderField: "User-Agent")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = method
        urlRequest.httpBody = request.body
        urlRequest.allHTTPHeaderFields = request.headers

        session.dataTask(with: urlRequest, completionHandler: { (data, _, error) in
            DispatchQueue.main.async {
                completionHandler(data, error)
            }
        }).resume()
    }

}
