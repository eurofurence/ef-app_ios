//
//  Identifyable.swift
//  EurofurenceModel
//
//  Created by Thomas Sherwood on 18/03/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import Foundation

public protocol Identifyable {
    
    associatedtype Identifier
    
    var identifier: Identifier { get }
    
}
