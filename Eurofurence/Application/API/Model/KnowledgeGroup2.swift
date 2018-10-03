//
//  KnowledgeGroup2.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 23/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public struct KnowledgeGroup2: Comparable, Equatable {

    public struct Identifier: Comparable, Equatable, Hashable, RawRepresentable {

        public typealias RawValue = String

        public init(_ value: String) {
            self.rawValue = value
        }

        public init?(rawValue: String) {
            self.rawValue = rawValue
        }

        public var rawValue: String

        public static func < (lhs: KnowledgeGroup2.Identifier, rhs: KnowledgeGroup2.Identifier) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }

    }

    public var identifier: KnowledgeGroup2.Identifier
    public var title: String
    public var groupDescription: String
    public var fontAwesomeCharacterAddress: Character
    public var order: Int
    public var entries: [KnowledgeEntry2]

    public init(identifier: KnowledgeGroup2.Identifier, title: String, groupDescription: String, fontAwesomeCharacterAddress: Character, order: Int, entries: [KnowledgeEntry2]) {
        self.identifier = identifier
        self.title = title
        self.groupDescription = groupDescription
        self.fontAwesomeCharacterAddress = fontAwesomeCharacterAddress
        self.order = order
        self.entries = entries
    }

    public static func <(lhs: KnowledgeGroup2, rhs: KnowledgeGroup2) -> Bool {
        return lhs.order < rhs.order
    }

}

public extension KnowledgeGroup2 {

    public static func fromServerModels(groups: [APIKnowledgeGroup], entries: [APIKnowledgeEntry]) -> [KnowledgeGroup2] {
        return groups.map({ (group) -> KnowledgeGroup2 in
            let entries = entries.filter({ $0.groupIdentifier == group.identifier }).map(KnowledgeEntry2.fromServerModel).sorted()
            let defaultFontAwesomeBackupCharacter: Character = " "
            let fontAwesomeCharacter: Character = Int(group.fontAwesomeCharacterAddress, radix: 16)
                .let(UnicodeScalar.init)
                .let(Character.init)
                .or(defaultFontAwesomeBackupCharacter)

            return KnowledgeGroup2(identifier: KnowledgeGroup2.Identifier(group.identifier),
                                   title: group.groupName,
                                   groupDescription: group.groupDescription,
                                   fontAwesomeCharacterAddress: fontAwesomeCharacter,
                                   order: group.order,
                                   entries: entries)
        }).sorted()
    }

}
