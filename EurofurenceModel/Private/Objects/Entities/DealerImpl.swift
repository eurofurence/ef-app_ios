//
//  DealerImpl.swift
//  EurofurenceModel
//
//  Created by Thomas Sherwood on 15/02/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import EventBus
import Foundation

struct DealerImpl: Dealer {
    
    private let eventBus: EventBus
    private let dataStore: DataStore
    private let imageCache: ImagesCache
    private let mapCoordinateRender: MapCoordinateRender?
    private let characteristics: DealerCharacteristics

    var identifier: DealerIdentifier

    var preferredName: String {
        if characteristics.displayName.isEmpty {
            if characteristics.attendeeNickname.isEmpty {
                return "?"
            }
            
            return characteristics.attendeeNickname
        }
        
        return characteristics.displayName
    }
    
    var alternateName: String? {
        if isNicknameEqualToDisplayName() {
            return nil
        } else {
            return characteristics.attendeeNickname
        }
    }

    var isAttendingOnThursday: Bool
    var isAttendingOnFriday: Bool
    var isAttendingOnSaturday: Bool

    var isAfterDark: Bool

    init(eventBus: EventBus,
         dataStore: DataStore,
         imageCache: ImagesCache,
         mapCoordinateRender: MapCoordinateRender?,
         characteristics: DealerCharacteristics) {
        self.eventBus = eventBus
        self.dataStore = dataStore
        self.imageCache = imageCache
        self.mapCoordinateRender = mapCoordinateRender
        self.characteristics = characteristics
        
        self.identifier = DealerIdentifier(characteristics.identifier)
        self.isAttendingOnThursday = characteristics.attendsOnThursday
        self.isAttendingOnFriday = characteristics.attendsOnFriday
        self.isAttendingOnSaturday = characteristics.attendsOnSaturday
        self.isAfterDark = characteristics.isAfterDark
    }
    
    func openWebsite() {
        guard let externalLink = characteristics.links?.first(where: { $0.fragmentType == .WebExternal }) else { return }
        guard let url = URL(string: externalLink.target) else { return }
        
        eventBus.post(DomainEvent.OpenURL(url: url))
    }
    
    func openTwitter() {
        guard characteristics.twitterHandle.isEmpty == false else { return }
        guard let url = URL(string: "https://twitter.com/")?.appendingPathComponent(characteristics.twitterHandle) else { return }
        
        eventBus.post(DomainEvent.OpenURL(url: url))
    }
    
    func openTelegram() {
        guard characteristics.telegramHandle.isEmpty == false else { return }
        guard let url = URL(string: "https://t.me/")?.appendingPathComponent(characteristics.twitterHandle) else { return }
        
        eventBus.post(DomainEvent.OpenURL(url: url))
    }
    
    func fetchExtendedDealerData(completionHandler: @escaping (ExtendedDealerData) -> Void) {
        var dealerMapLocationData: Data?
        if let (map, entry) = fetchMapData(), let mapData = imageCache.cachedImageData(for: map.imageIdentifier) {
            dealerMapLocationData = mapCoordinateRender?.render(x: entry.x, y: entry.y, radius: entry.tapRadius, onto: mapData)
        }
        
        var artistImagePNGData: Data?
        if let artistImageId = characteristics.artistImageId {
            artistImagePNGData = imageCache.cachedImageData(for: artistImageId)
        }
        
        var artPreviewImagePNGData: Data?
        if let artPreviewImageId = characteristics.artPreviewImageId {
            artPreviewImagePNGData = imageCache.cachedImageData(for: artPreviewImageId)
        }
        
        let convertEmptyStringsIntoNil: (String) -> String? = { $0.isEmpty ? nil : $0 }
        
        let extendedData = ExtendedDealerData(artistImagePNGData: artistImagePNGData,
                                              dealersDenMapLocationGraphicPNGData: dealerMapLocationData,
                                              preferredName: preferredName,
                                              alternateName: alternateName,
                                              categories: characteristics.categories.sorted(),
                                              dealerShortDescription: characteristics.shortDescription,
                                              isAttendingOnThursday: isAttendingOnThursday,
                                              isAttendingOnFriday: isAttendingOnFriday,
                                              isAttendingOnSaturday: isAttendingOnSaturday,
                                              isAfterDark: characteristics.isAfterDark,
                                              websiteName: characteristics.links?.first(where: { $0.fragmentType == .WebExternal })?.target,
                                              twitterUsername: convertEmptyStringsIntoNil(characteristics.twitterHandle),
                                              telegramUsername: convertEmptyStringsIntoNil(characteristics.telegramHandle),
                                              aboutTheArtist: convertEmptyStringsIntoNil(characteristics.aboutTheArtistText),
                                              aboutTheArt: convertEmptyStringsIntoNil(characteristics.aboutTheArtText),
                                              artPreviewImagePNGData: artPreviewImagePNGData,
                                              artPreviewCaption: convertEmptyStringsIntoNil(characteristics.artPreviewCaption))
        completionHandler(extendedData)
    }
    
    func fetchIconPNGData(completionHandler: @escaping (Data?) -> Void) {
        var iconData: Data?
        if let iconIdentifier = characteristics.artistThumbnailImageId {
            iconData = imageCache.cachedImageData(for: iconIdentifier)
        }
        
        completionHandler(iconData)
    }
    
    private func fetchMapData() -> (map: MapCharacteristics, entry: MapCharacteristics.Entry)? {
        guard let maps = dataStore.fetchMaps() else { return nil }
        
        for map in maps {
            guard let entry = map.entries.first(where: { (entry) -> Bool in
                return entry.links.contains(where: { $0.target == identifier.rawValue })
            }) else { continue }
            
            return (map: map, entry: entry)
        }
        
        return nil
    }
    
    private func isNicknameEqualToDisplayName() -> Bool {
        return characteristics.attendeeNickname == characteristics.displayName
    }

}
