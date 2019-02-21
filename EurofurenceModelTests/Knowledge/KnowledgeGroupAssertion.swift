//
//  KnowledgeGroupAssertion.swift
//  EurofurenceModelTests
//
//  Created by Thomas Sherwood on 14/02/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import EurofurenceModel
import TestUtilities

class KnowledgeGroupAssertion: Assertion {

    func assertGroups(_ groups: [KnowledgeGroup],
                      characterisedByGroup groupCharacteristics: [KnowledgeGroupCharacteristics],
                      entries: [KnowledgeEntryCharacteristics]) {
        guard groups.count == groupCharacteristics.count else {
            fail(message: "Expected \(groupCharacteristics.count) groups, got \(groups.count)")
            return
        }

        let orderedGroupCharacteristics = groupCharacteristics.sorted(by: { $0.order < $1.order })
        for (idx, group) in groups.enumerated() {
            let characteristic = orderedGroupCharacteristics[idx]
            assertGroup(group, characterisedByGroup: characteristic, entries: entries)
        }
    }

    func assertGroup(_ group: KnowledgeGroup?,
                     characterisedByGroup groupCharacteristics: KnowledgeGroupCharacteristics,
                     entries: [KnowledgeEntryCharacteristics]) {
        guard let group = group else {
            fail(message: "Expected a group")
            return
        }

        assert(groupCharacteristics.identifier, isEqualTo: group.identifier.rawValue)
        assert(groupCharacteristics.groupName, isEqualTo: group.title)
        assert(groupCharacteristics.groupDescription, isEqualTo: group.groupDescription)
        assert(groupCharacteristics.order, isEqualTo: group.order)

        let addressString = groupCharacteristics.fontAwesomeCharacterAddress
        let intValue = Int(addressString, radix: 16)!
        let unicodeScalar = UnicodeScalar(intValue)!
        let character = Character(unicodeScalar)
        assert(character, isEqualTo: group.fontAwesomeCharacterAddress)

        let entriesForGroup = entries.filter({ $0.groupIdentifier == groupCharacteristics.identifier })
        guard entriesForGroup.count == group.entries.count else {
            fail(message: "Expected \(entriesForGroup.count) entries for group \(group.identifier), got \(group.entries.count)")
            return
        }

        let orderedEntries = entriesForGroup.sorted(by: { $0.order < $1.order })
        for (idx, entry) in group.entries.enumerated() {
            let entryCharacteristic = orderedEntries[idx]
            KnowledgeEntryAssertion(file: file, line: line).assertEntry(entry, characteristics: entryCharacteristic)
        }
    }

}
