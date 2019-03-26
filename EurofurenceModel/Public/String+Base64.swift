//
//  String+Base64.swift
//  EurofurenceModel
//
//  Created by Thomas Sherwood on 18/03/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import Foundation

public extension String {
    
    var base64EncodedString: String {
        return data(using: .utf8)?.base64EncodedString() ?? ""
    }
    
}
