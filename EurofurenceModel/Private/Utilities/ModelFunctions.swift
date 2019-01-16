//
//  ModelFunctions.swift
//  EurofurenceModel
//
//  Created by Thomas Sherwood on 16/01/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import Foundation

func not<T>(_ predicate: @escaping (T) -> Bool) -> (T) -> Bool {
    return { (element) in return !predicate(element) }
}
