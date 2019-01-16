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

    private var dealerModels = [Dealer]()
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

    func makeDealersIndex() -> DealersIndex {
        return Index(dealers: self, eventBus: eventBus)
    }

    func fetchIconPNGData(for identifier: DealerIdentifier, completionHandler: @escaping (Data?) -> Void) {
        guard let dealer = fetchDealer(identifier) else { return }

        var iconData: Data?
        if let iconIdentifier = dealer.artistThumbnailImageId {
            iconData = imageCache.cachedImageData(for: iconIdentifier)
        }

        completionHandler(iconData)
    }

    private func fetchMapData(for identifier: DealerIdentifier) -> (map: MapCharacteristics, entry: MapCharacteristics.Entry)? {
        guard let maps = dataStore.getSavedMaps() else { return nil }

        for map in maps {
            guard let entry = map.entries.first(where: { (entry) -> Bool in
                return entry.links.contains(where: { $0.target == identifier.rawValue })
            }) else { continue }

            return (map: map, entry: entry)
        }

        return nil
    }

    func fetchExtendedDealerData(for dealer: DealerIdentifier, completionHandler: @escaping (ExtendedDealerData) -> Void) {
        guard let dealerModel = dealerModels.first(where: { $0.identifier == dealer }) else { return }
        guard let model = fetchDealer(dealer) else { return }

        var dealerMapLocationData: Data?
        if let (map, entry) = fetchMapData(for: dealer), let mapData = imageCache.cachedImageData(for: map.imageIdentifier) {
            dealerMapLocationData = mapCoordinateRender?.render(x: entry.x, y: entry.y, radius: entry.tapRadius, onto: mapData)
        }

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
                                              dealersDenMapLocationGraphicPNGData: dealerMapLocationData,
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

    func openWebsite(for identifier: DealerIdentifier) {
        guard let dealer = fetchDealer(identifier) else { return }
        guard let externalLink = dealer.links?.first(where: { $0.fragmentType == .WebExternal }) else { return }
        guard let url = URL(string: externalLink.target) else { return }

        open(url)
    }

    func openTwitter(for identifier: DealerIdentifier) {
        guard let dealer = fetchDealer(identifier), dealer.twitterHandle.isEmpty == false else { return }
        guard let url = URL(string: "https://twitter.com/")?.appendingPathComponent(dealer.twitterHandle) else { return }

        open(url)
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
        guard let dealers = dataStore.getSavedDealers() else { return }

        models = dealers
        dealerModels = models.map { (dealer) -> Dealer in
            var preferredName = dealer.displayName
            if preferredName.isEmpty {
                preferredName = dealer.attendeeNickname
                if preferredName.isEmpty {
                    preferredName = "?"
                }
            }

            return Dealer(identifier: DealerIdentifier(dealer.identifier),
                           preferredName: preferredName,
                           alternateName: dealer.attendeeNickname == dealer.displayName ? nil : dealer.attendeeNickname,
                           isAttendingOnThursday: dealer.attendsOnThursday,
                           isAttendingOnFriday: dealer.attendsOnFriday,
                           isAttendingOnSaturday: dealer.attendsOnSaturday,
                           isAfterDark: dealer.isAfterDark)
        }

        eventBus.post(ConcreteDealersService.UpdatedEvent())
    }

    func dealer(for identifier: String) -> Dealer? {
        return dealerModels.first(where: { $0.identifier.rawValue == identifier })
    }

}
