import EurofurenceModel
import Foundation

public class CapturingJSONSession: JSONSession {

    public init() {

    }

    public private(set) var getRequestURL: String?
    public private(set) var capturedAdditionalGETHeaders: [String: String]?
    private var GETCompletionHandler: ((Data?, Error?) -> Void)?
    public func get(_ request: JSONRequest, completionHandler: @escaping (Data?, Error?) -> Void) {
        getRequestURL = request.url
        capturedAdditionalGETHeaders = request.headers
        GETCompletionHandler = completionHandler
    }

    public private(set) var postedURL: String?
    public private(set) var capturedAdditionalPOSTHeaders: [String: String]?
    public private(set) var POSTData: Data?
    private var POSTCompletionHandler: ((Data?, Error?) -> Void)?
    public func post(_ request: JSONRequest, completionHandler: @escaping (Data?, Error?) -> Void) {
        postedURL = request.url
        POSTData = request.body
        self.POSTCompletionHandler = completionHandler
        capturedAdditionalPOSTHeaders = request.headers
    }

    public func postedJSONValue<T>(forKey key: String) -> T? {
        guard let POSTData = POSTData else { return nil }
        guard let json = try? JSONSerialization.jsonObject(with: POSTData, options: .allowFragments) else { return nil }
        guard let jsonDictionary = json as? [String: Any] else { return nil }

        return jsonDictionary[key] as? T
    }

    public func invokeLastGETCompletionHandler(responseData: Data?) {
        GETCompletionHandler?(responseData, nil)
    }

    public func invokeLastPOSTCompletionHandler(responseData: Data?, error: Error? = nil) {
        POSTCompletionHandler?(responseData, error)
    }

}
