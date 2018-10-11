//
//  CapturingJSONSession.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import Foundation

public class CapturingJSONSession: JSONSession {

    public init() {

    }

    private(set) public var getRequestURL: String?
    private(set) public var capturedAdditionalGETHeaders: [String: String]?
    private var GETCompletionHandler: ((Data?, Error?) -> Void)?
    public func get(_ request: JSONRequest, completionHandler: @escaping (Data?, Error?) -> Void) {
        getRequestURL = request.url
        capturedAdditionalGETHeaders = request.headers
        GETCompletionHandler = completionHandler
    }

    private(set) public var postedURL: String?
    private(set) public var capturedAdditionalPOSTHeaders: [String: String]?
    private(set) public var POSTData: Data?
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
