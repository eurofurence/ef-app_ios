//
//  CapturingJSONPoster.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingJSONPoster: JSONPoster {

    private(set) var postedURL: String?
    private(set) var capturedAdditionalHeaders: [String : String]?
    private var postedData: Data?
    private var completionHandler: ((Data?) -> Void)?
    func post(_ url: String, body: Data, headers: [String : String], completionHandler: @escaping (Data?) -> Void) {
        postedURL = url
        postedData = body
        self.completionHandler = completionHandler
        capturedAdditionalHeaders = headers
    }

    func postedJSONValue<T>(forKey key: String) -> T? {
        guard let postedData = postedData else { return nil }
        guard let json = try? JSONSerialization.jsonObject(with: postedData, options: .allowFragments) else { return nil }
        guard let jsonDictionary = json as? [String : Any] else { return nil }

        return jsonDictionary[key] as? T
    }
    
    func invokeLastCompletionHandler(responseData: Data?) {
        completionHandler?(responseData)
    }
    
}
