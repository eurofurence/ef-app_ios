//
//  CapturingHTTPPoster.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingHTTPPoster: HTTPPoster {

    private(set) var postedURL: String?
    private var postedData: Data?
    func post(_ url: String, body: Data) {
        postedURL = url
        postedData = body
    }

    func postedJSONValue<T>(forKey key: String) -> T? {
        guard let postedData = postedData else { return nil }
        guard let json = try? JSONSerialization.jsonObject(with: postedData, options: .allowFragments) else { return nil }
        guard let jsonDictionary = json as? [String : Any] else { return nil }

        return jsonDictionary[key] as? T
    }
    
}
