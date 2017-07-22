//
//  APIResponse.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 20/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

enum APIResponse<T> {
    case success(T)
    case failure
}
