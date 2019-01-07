//
//  Identifier.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 07/01/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import Foundation

public struct Identifier<T>: Equatable, Hashable, RawRepresentable {
    
    public typealias RawValue = String
    
    public init(_ value: String) {
        self.rawValue = value
    }
    
    public init?(rawValue: String) {
        self.rawValue = rawValue
    }
    
    public var rawValue: String
    
}
