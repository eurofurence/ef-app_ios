//
//  ConcreteDealersService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 19/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EventBus
import Foundation

class ConcreteDealersService: DealersService {

    private class Index: DealersIndex, EventConsumer {

        private let dealers: ConcreteDealersService
        private var alphebetisedDealers = [AlphabetisedDealersGroup]()

        init(dealers: ConcreteDealersService, eventBus: EventBus) {
            self.dealers = dealers
            eventBus.subscribe(consumer: self)
        }

        func performSearch(term: String) {
            let matches = alphebetisedDealers.compactMap { (group) -> AlphabetisedDealersGroup? in
                let matchingDealers = group.dealers.compactMap { (dealer) -> Dealer? in
                    let preferredNameMatches = dealer.preferredName.localizedCaseInsensitiveContains(term)
                    var alternateNameMatches = false
                    if let alternateName = dealer.alternateName {
                        alternateNameMatches = alternateName.localizedCaseInsensitiveContains(term)
                    }

                    guard preferredNameMatches || alternateNameMatches else { return nil }

                    return dealer
                }

                guard matchingDealers.isEmpty == false else { return nil }
                return AlphabetisedDealersGroup(indexingString: group.indexingString, dealers: matchingDealers)
            }

            delegate?.indexDidProduceSearchResults(matches)
        }

        private var delegate: DealersIndexDelegate?
        func setDelegate(_ delegate: DealersIndexDelegate) {
            self.delegate = delegate
            updateAlphebetisedDealers()
            delegate.alphabetisedDealersDidChange(to: alphebetisedDealers)
        }

        func consume(event: ConcreteDealersService.UpdatedEvent) {
            updateAlphebetisedDealers()
            delegate?.alphabetisedDealersDidChange(to: alphebetisedDealers)
        }

        private func updateAlphebetisedDealers() {
            let grouped = Dictionary(grouping: dealers.dealerModels) { String($0.preferredName.first!).uppercased() }
            let sortedGroups = grouped.sorted(by: { $0.key < $1.key })
            alphebetisedDealers = sortedGroups.map({ (arg) -> AlphabetisedDealersGroup in
                let (index, dealers) = arg
                return AlphabetisedDealersGroup(indexingString: index,
                                                dealers: dealers.sorted(by: { $0.preferredName < $1.preferredName }))
            })
        }

    }

    private struct UpdatedEvent {}

    private var dealerModels = [DealerImpl]()
    private var models = [DealerCharacteristics]()
    private let eventBus: EventBus
    private let dataStore: DataStore
    private let imageCache: ImagesCache
    private let mapCoordinateRender: MapCoordinateRender?

    init(eventBus: EventBus,
         dataStore: DataStore,
         imageCache: ImagesCache,
         mapCoordinateRender: MapCoordinateRender?) {
        self.eventBus = eventBus
        self.dataStore = dataStore
        self.imageCache = imageCache
        self.mapCoordinateRender = mapCoordinateRender

        eventBus.subscribe(consumer: DataStoreChangedConsumer(handler: reloadDealersFromDataStore))
        reloadDealersFromDataStore()
    }
    
    func fetchDealer(for identifier: DealerIdentifier) -> Dealer? {
        return dealerModels.first(where: { $0.identifier == identifier })
    }

    func makeDealersIndex() -> DealersIndex {
        return Index(dealers: self, eventBus: eventBus)
    }

    func openTelegram(for identifier: DealerIdentifier) {
        guard let dealer = fetchDealer(identifier), dealer.telegramHandle.isEmpty == false else { return }
        guard let url = URL(string: "https://t.me/")?.appendingPathComponent(dealer.twitterHandle) else { return }

        open(url)
    }

    private func open(_ url: URL) {
        eventBus.post(DomainEvent.OpenURL(url: url))
    }

    private func fetchDealer(_ identifier: DealerIdentifier) -> DealerCharacteristics? {
        return models.first(where: { $0.identifier == identifier.rawValue })
    }

    fileprivate func reloadDealersFromDataStore() {
        guard let dealers = dataStore.fetchDealers() else { return }

        models = dealers
        dealerModels = models.map { (dealer) -> DealerImpl in
            var preferredName = dealer.displayName
            if preferredName.isEmpty {
                preferredName = dealer.attendeeNickname
                if preferredName.isEmpty {
                    preferredName = "?"
                }
            }

            return DealerImpl(eventBus: self.eventBus,
                              dataStore: self.dataStore,
                              imageCache: self.imageCache,
                              mapCoordinateRender: self.mapCoordinateRender,
                              identifier: DealerIdentifier(dealer.identifier),
                              preferredName: preferredName,
                              alternateName: dealer.attendeeNickname == dealer.displayName ? nil : dealer.attendeeNickname,
                              isAttendingOnThursday: dealer.attendsOnThursday,
                              isAttendingOnFriday: dealer.attendsOnFriday,
                              isAttendingOnSaturday: dealer.attendsOnSaturday,
                              isAfterDark: dealer.isAfterDark)
        }

        eventBus.post(ConcreteDealersService.UpdatedEvent())
    }

}
