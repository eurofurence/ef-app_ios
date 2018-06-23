//
//  Dealers.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 19/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

class Dealers: DealersService {

    private class Index: DealersIndex, EventConsumer {

        private let dealers: Dealers
        private var alphebetisedDealers = [AlphabetisedDealersGroup]()

        init(dealers: Dealers, eventBus: EventBus) {
            self.dealers = dealers
            eventBus.subscribe(consumer: self)
        }

        func performSearch(term: String) {
            let matches = alphebetisedDealers.compactMap { (group) -> AlphabetisedDealersGroup? in
                let matchingDealers = group.dealers.compactMap { (dealer) -> Dealer2? in
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

        func consume(event: Dealers.UpdatedEvent) {
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

    private class UpdateDealersWhenSyncOccurs: EventConsumer {

        private let dealers: Dealers

        init(dealers: Dealers) {
            self.dealers = dealers
        }

        func consume(event: DomainEvent.LatestDataFetchedEvent) {
            dealers.updateDealers(from: event.response.dealers.changed)
        }

    }

    private struct UpdatedEvent {}

    private var dealerModels = [Dealer2]()
    private var models = [APIDealer]()
    private let eventBus: EventBus
    private let imageCache: ImagesCache

    init(eventBus: EventBus, dataStore: EurofurenceDataStore, imageCache: ImagesCache) {
        self.eventBus = eventBus
        self.imageCache = imageCache
        eventBus.subscribe(consumer: UpdateDealersWhenSyncOccurs(dealers: self))

        if let savedDealers = dataStore.getSavedDealers() {
            updateDealers(from: savedDealers)
        }
    }

    func makeDealersIndex() -> DealersIndex {
        return Index(dealers: self, eventBus: eventBus)
    }

    func fetchIconPNGData(for identifier: Dealer2.Identifier, completionHandler: @escaping (Data?) -> Void) {
        guard let dealer = models.first(where: { $0.identifier == identifier.rawValue }) else { return }

        var iconData: Data?
        if let iconIdentifier = dealer.artistThumbnailImageId {
            iconData = imageCache.cachedImageData(for: iconIdentifier)
        }

        completionHandler(iconData)
    }

    func fetchExtendedDealerData(for dealer: Dealer2.Identifier, completionHandler: @escaping (ExtendedDealerData) -> Void) {
        guard let model = dealerModels.first(where: { $0.identifier == dealer }) else { return }

        let extendedData = ExtendedDealerData(artistImagePNGData: nil,
                                              dealersDenMapLocationGraphicPNGData: nil,
                                              preferredName: model.preferredName,
                                              alternateName: model.alternateName,
                                              categories: [],
                                              dealerShortDescription: "",
                                              isAttendingOnThursday: model.isAttendingOnThursday,
                                              isAttendingOnFriday: model.isAttendingOnFriday,
                                              isAttendingOnSaturday: model.isAttendingOnSaturday,
                                              isAfterDark: model.isAfterDark,
                                              websiteName: nil,
                                              twitterUsername: nil,
                                              telegramUsername: nil,
                                              aboutTheArtist: nil,
                                              aboutTheArt: nil,
                                              artPreviewImagePNGData: nil,
                                              artPreviewCaption: nil)
        completionHandler(extendedData)
    }

    private func updateDealers(from dealers: [APIDealer]) {
        models = dealers
        dealerModels = dealers.map { (dealer) -> Dealer2 in
            var preferredName = dealer.displayName
            if preferredName.isEmpty {
                preferredName = dealer.attendeeNickname
                if preferredName.isEmpty {
                    preferredName = "?"
                }
            }

            return Dealer2(identifier: Dealer2.Identifier(dealer.identifier),
                           preferredName: preferredName,
                           alternateName: dealer.attendeeNickname == dealer.displayName ? nil : dealer.attendeeNickname,
                           isAttendingOnThursday: dealer.attendsOnThursday,
                           isAttendingOnFriday: dealer.attendsOnFriday,
                           isAttendingOnSaturday: dealer.attendsOnSaturday,
                           isAfterDark: dealer.isAfterDark)
        }

        eventBus.post(Dealers.UpdatedEvent())
    }

}
