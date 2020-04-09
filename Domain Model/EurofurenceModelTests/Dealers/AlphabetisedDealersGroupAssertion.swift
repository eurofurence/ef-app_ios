import EurofurenceModel
import TestUtilities

class AlphabetisedDealersGroupAssertion: Assertion {

    private let groups: [AlphabetisedDealersGroup]
    private let characteristics: [DealerCharacteristics]

    init(groups: [AlphabetisedDealersGroup],
         fromDealerCharacteristics characteristics: [DealerCharacteristics],
         file: StaticString = #file,
         line: UInt = #line) {
        self.groups = groups
        self.characteristics = characteristics

        super.init(file: file, line: line)
    }

    func assertGroups() {
        if expectedIndexGroupsArePresent() {
            assertEachGroupContainsExpectedDealers()
        }
    }

    private func expectedIndexGroupsArePresent() -> Bool {
        let indexTitles = makeIndexTitlesFromCharacteristics()
        let expectedNumberOfGroupsPresent = indexTitles.count == groups.count

        if expectedNumberOfGroupsPresent == false {
            let groupIndexTitles = groups.map(\.indexingString)
            fail(message: "Expected \(indexTitles) groups, got \(groupIndexTitles)")
        }

        return expectedNumberOfGroupsPresent
    }

    private func assertEachGroupContainsExpectedDealers() {
        groups.forEach(assertGroupContainsExpectedDealers)
    }

    private func makeIndexTitlesFromCharacteristics() -> [String] {
        let indexTitles: [String] = characteristics.map({ String($0.displayName.first.unsafelyUnwrapped) })
        let titlesSet = Set(indexTitles)

        return titlesSet.sorted()
    }

    private func assertGroupContainsExpectedDealers(_ group: AlphabetisedDealersGroup) {
        if doesGroupContainExpectedNumberOfDealers(group) {
            assertDealerContentsWithinGroup(group)
        }
    }

    func doesGroupContainExpectedNumberOfDealers(_ group: AlphabetisedDealersGroup) -> Bool {
        let groupIndexTitle = group.indexingString.lowercased()
        let dealersWithIndexingPrefix = characteristics.filter({ $0.displayName.lowercased().starts(with: groupIndexTitle) })
        let isExpectedNumberOfDealersPresent = dealersWithIndexingPrefix.count == group.dealers.count

        if isExpectedNumberOfDealersPresent == false {
            fail(message: "Expected \(dealersWithIndexingPrefix.count) dealers in group \(groupIndexTitle), got \(group.dealers)")
        }

        return isExpectedNumberOfDealersPresent
    }

    private func assertDealerContentsWithinGroup(_ group: AlphabetisedDealersGroup) {
        let dealersAndCharacteristics = resolveCharacteristicsForDealers(group.dealers)
        guard dealersAndCharacteristics.count == group.dealers.count else {
            fail(message: "Unable to lookup all dealer characteristics")
            return
        }

        assertDealersMatchCharacteristics(dealersAndCharacteristics)
    }

    private typealias DealerAndCharacteristics = (Dealer, DealerCharacteristics)

    private func resolveCharacteristicsForDealers(_ dealers: [Dealer]) -> [DealerAndCharacteristics] {
        return dealers.compactMap(characteristicsForDealer)
    }

    private func characteristicsForDealer(_ dealer: Dealer) -> DealerAndCharacteristics? {
        if let characteristics = characteristics.first(where: { $0.identifier == dealer.identifier.rawValue }) {
            return (dealer, characteristics)
        } else {
            return nil
        }
    }

    private func assertDealersMatchCharacteristics(_ dealersAndCharacteristics: [AlphabetisedDealersGroupAssertion.DealerAndCharacteristics]) {
        let dealerAssertion = DealerAssertion()
        for (dealer, characteristic) in dealersAndCharacteristics {
            dealerAssertion.assertDealer(dealer, characterisedBy: characteristic)
        }
    }

}
