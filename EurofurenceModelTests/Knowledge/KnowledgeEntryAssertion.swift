//
//  KnowledgeEntryAssertion.swift
//  EurofurenceModelTests
//
//  Created by Thomas Sherwood on 15/02/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import EurofurenceModel
import TestUtilities

class KnowledgeEntryAssertion: Assertion {

    func assertEntry(_ entry: KnowledgeEntry?, characteristics: KnowledgeEntryCharacteristics) {
        guard let entry = entry else {
            fail(message: "Expected an entry")
            return
        }

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
