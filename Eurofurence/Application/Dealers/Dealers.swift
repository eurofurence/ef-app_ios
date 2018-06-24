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
    private let urlOpener: URLOpener

    var externalContentHandler: ExternalContentHandler?

    init(eventBus: EventBus, dataStore: EurofurenceDataStore, imageCache: ImagesCache, urlOpener: URLOpener) {
        self.eventBus = eventBus
        self.imageCache = imageCache
        self.urlOpener = urlOpener

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
        guard let dealerModel = dealerModels.first(where: { $0.identifier == dealer }) else { return }
        guard let model = models.first(where: { $0.identifier == dealer.rawValue }) else { return }

        var artistImagePNGData: Data?
        if let artistImageId = model.artistImageId {
            artistImagePNGData = imageCache.cachedImageData(for: artistImageId)
        }

        var artPreviewImagePNGData: Data?
        if let artPreviewImageId = model.artPreviewImageId {
            artPreviewImagePNGData = imageCache.cachedImageData(for: artPreviewImageId)
        }

        let convertEmptyStringsIntoNil: (String) -> String? = { $0.isEmpty ? nil : $0 }

        let extendedData = ExtendedDealerData(artistImagePNGData: artistImagePNGData,
                                              dealersDenMapLocationGraphicPNGData: nil,
                                              preferredName: dealerModel.preferredName,
                                              alternateName: dealerModel.alternateName,
                                              categories: model.categories.sorted(),
                                              dealerShortDescription: model.shortDescription,
                                              isAttendingOnThursday: dealerModel.isAttendingOnThursday,
                                              isAttendingOnFriday: dealerModel.isAttendingOnFriday,
                                              isAttendingOnSaturday: dealerModel.isAttendingOnSaturday,
                                              isAfterDark: dealerModel.isAfterDark,
                                              websiteName: model.links?.first(where: { $0.fragmentType == .WebExternal })?.target,
                                              twitterUsername: convertEmptyStringsIntoNil(model.twitterHandle),
                                              telegramUsername: convertEmptyStringsIntoNil(model.telegramHandle),
                                              aboutTheArtist: convertEmptyStringsIntoNil(model.aboutTheArtistText),
                                              aboutTheArt: convertEmptyStringsIntoNil(model.aboutTheArtText),
                                              artPreviewImagePNGData: artPreviewImagePNGData,
                                              artPreviewCaption: convertEmptyStringsIntoNil(model.artPreviewCaption))
        completionHandler(extendedData)
    }

    func openWebsite(for identifier: Dealer2.Identifier) {
        guard let dealer = models.first(where: { $0.identifier == identifier.rawValue }) else { return }
        guard let externalLink = dealer.links?.first(where: { $0.fragmentType == .WebExternal }) else { return }
        guard let url = URL(string: externalLink.target) else { return }

        if urlOpener.canOpen(url) {
            urlOpener.open(url)
        }

        externalContentHandler?.handleExternalContent(url: url)
    }

    func openTwitter(for identifier: Dealer2.Identifier) {

    }

    func openTelegram(for identifier: Dealer2.Identifier) {

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
