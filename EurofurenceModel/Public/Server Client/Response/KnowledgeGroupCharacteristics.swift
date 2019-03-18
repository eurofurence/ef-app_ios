//
//  KnowledgeGroupCharacteristics.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 26/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public struct KnowledgeGroupCharacteristics: Equatable, Identifyable {

    public var identifier: String
    
    public var order: Int
    public var groupName: String
    public var groupDescription: String
    public var fontAwesomeCharacterAddress: String

    public init(identifier: String, order: Int, groupName: String, groupDescription: String, fontAwesomeCharacterAddress: String) {
        self.identifier = identifier
        self.order = order
        self.groupName = groupName
        self.groupDescription = groupDescription
        self.fontAwesomeCharacterAddress = fontAwesomeCharacterAddress
    }

}
