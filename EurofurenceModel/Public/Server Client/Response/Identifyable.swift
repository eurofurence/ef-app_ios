//
//  Identifyable.swift
//  EurofurenceModel
//
//  Created by Thomas Sherwood on 18/03/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import Foundation

public protocol Identifyable {
    
    associatedtype Identifier: Equatable
    
    var identifier: Identifier { get }
    
}

extension Array where Element: Identifyable {
    
    var identifiers: [Element.Identifier] {
        return map({ $0.identifier })
    }
    
}
