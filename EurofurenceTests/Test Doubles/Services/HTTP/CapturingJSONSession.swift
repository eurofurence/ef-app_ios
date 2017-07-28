//
//  CapturingJSONSession.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingJSONSession: JSONSession {
    
    private(set) var getRequestURL: String?
    private(set) var capturedAdditionalGETHeaders: [String : String]?
    private var GETCompletionHandler: ((Data?, Error?) -> Void)?
    func get(_ request: Request, completionHandler: @escaping (Data?, Error?) -> Void) {
        getRequestURL = request.url
        capturedAdditionalGETHeaders = request.headers
        GETCompletionHandler = completionHandler
    }

    private(set) var postedURL: String?
    private(set) var capturedAdditionalPOSTHeaders: [String : String]?
    private var POSTData: Data?
    private var POSTCompletionHandler: ((Data?, Error?) -> Void)?
    func post(_ request: Request, completionHandler: @escaping (Data?, Error?) -> Void) {
        postedURL = request.url
        POSTData = request.body
        self.POSTCompletionHandler = completionHandler
        capturedAdditionalPOSTHeaders = request.headers
    }

    func postedJSONValue<T>(forKey key: String) -> T? {
        guard let POSTData = POSTData else { return nil }
        guard let json = try? JSONSerialization.jsonObject(with: POSTData, options: .allowFragments) else { return nil }
        guard let jsonDictionary = json as? [String : Any] else { return nil }

        return jsonDictionary[key] as? T
    }
    
    func invokeLastGETCompletionHandler(responseData: Data?) {
        GETCompletionHandler?(responseData, nil)
    }
    
    func invokeLastPOSTCompletionHandler(responseData: Data?, error: Error? = nil) {
        POSTCompletionHandler?(responseData, error)
    }
    
}
