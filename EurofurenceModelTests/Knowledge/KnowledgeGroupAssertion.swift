//
//  KnowledgeGroupAssertion.swift
//  EurofurenceModelTests
//
//  Created by Thomas Sherwood on 14/02/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import EurofurenceModel

class KnowledgeGroupAssertion: EntityAssertion {

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
            assertEntry(entry, characteristics: entryCharacteristic)
        }
    }

    private func assertEntry(_ entry: KnowledgeEntry, characteristics: KnowledgeEntryCharacteristics) {
        assert(characteristics.identifier, isEqualTo: entry.identifier.rawValue)
        assert(characteristics.title, isEqualTo: entry.title)
        assert(characteristics.order, isEqualTo: entry.order)
        assert(characteristics.text, isEqualTo: entry.contents)

        guard entry.links.count == characteristics.links.count else {
            fail(message: "Expected \(characteristics.links.count) links, got \(entry.links.count)")
            return
        }

        let orderedLinks = characteristics.links.sorted(by: { $0.name < $1.name })
        for (idx, link) in entry.links.enumerated() {
            let linkCharacteristics = orderedLinks[idx]
            assertLink(link, characteristics: linkCharacteristics)
        }
    }

    private func assertLink(_ link: Link, characteristics: LinkCharacteristics) {
        assert(characteristics.name, isEqualTo: link.name)
        assert(characteristics.target, isEqualTo: link.contents)
        assertTrue(isLinkKind(link.type, equalToFragmentType: characteristics.fragmentType))
    }

    private func isLinkKind(_ type: Link.Kind, equalToFragmentType fragmentType: LinkCharacteristics.FragmentType) -> Bool {
        switch (type, fragmentType) {
        case (.webExternal, .WebExternal):
            return true
        }
    }

}
