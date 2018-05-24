//
//  ImagesCache.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

class ImagesCache {

    private var cache = [String : Data]()

    public subscript(identifier: String) -> Data? {
        get {
            return cache[identifier]
        }
        set {
            cache[identifier] = newValue
        }
    }

}
