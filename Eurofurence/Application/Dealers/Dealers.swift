//
//  Dealers.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 19/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

class Dealers: DealersService {

    class Index: DealersIndex {

        private let dealers: Dealers
        private var alphebetisedDealers = [AlphabetisedDealersGroup]()

        init(dealers: Dealers) {
            self.dealers = dealers
        }

        func setDelegate(_ delegate: DealersIndexDelegate) {
            updateAlphebetisedDealers()
            delegate.alphabetisedDealersDidChange(to: alphebetisedDealers)
        }

        private func updateAlphebetisedDealers() {
            let grouped = Dictionary(grouping: dealers.dealerModels) { String($0.preferredName.first!) }
            let sortedGroups = grouped.sorted(by: { $0.key < $1.key })
            alphebetisedDealers = sortedGroups.map({ (arg) -> AlphabetisedDealersGroup in
                let (index, dealers) = arg
                return AlphabetisedDealersGroup(indexingString: index,
                                                dealers: dealers.sorted(by: { $0.preferredName < $1.preferredName }))
            })
        }

    }

    private class UpdateDealersWhenSyncOccurs: EventConsumer {

        private let dealers: Dealers

        init(dealers: Dealers) {
            self.dealers = dealers
        }

        func consume(event: DomainEvent.LatestDataFetchedEvent) {
            dealers.updateDealers(from: event.response)
        }

    }

    private var dealerModels = [Dealer2]()

    init(eventBus: EventBus) {
        eventBus.subscribe(consumer: UpdateDealersWhenSyncOccurs(dealers: self))
    }

    func makeDealersIndex() -> DealersIndex {
        return Index(dealers: self)
    }

    func fetchIconPNGData(for identifier: Dealer2.Identifier, completionHandler: @escaping (Data?) -> Void) {

    }

    private func updateDealers(from response: APISyncResponse) {
        dealerModels = response.dealers.changed.map { (dealer) -> Dealer2 in
            return Dealer2(identifier: Dealer2.Identifier(""),
                           preferredName: dealer.displayName,
                           alternateName: nil,
                           isAttendingOnThursday: false,
                           isAttendingOnFriday: false,
                           isAttendingOnSaturday: false,
                           isAfterDark: false)
        }
    }

}
