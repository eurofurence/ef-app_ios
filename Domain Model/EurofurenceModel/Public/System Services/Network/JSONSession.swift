import Foundation

public protocol JSONSession {

    func get(_ request: JSONRequest, completionHandler: @escaping (Data?, Error?) -> Void)
    func post(_ request: JSONRequest, completionHandler: @escaping (Data?, Error?) -> Void)

}

public struct JSONRequest {

    public var url: String
    public var body: Data
    public var headers: [String: String]

    public init(url: String, body: Data = Data(), headers: [String: String] = [:]) {
        self.url = url
        self.body = body
        self.headers = headers
    }

}
