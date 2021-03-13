import Foundation

struct DealerImpl: Dealer {
    
    private let eventBus: EventBus
    private let dataStore: DataStore
    private let imageCache: ImagesCache
    private let mapCoordinateRender: MapCoordinateRender?
    private let characteristics: DealerCharacteristics
    private let shareableURLFactory: ShareableURLFactory
    private let urlOpener: URLOpener?
    
    var categories: [String] {
        return characteristics.categories
    }

    var identifier: DealerIdentifier

    var preferredName: String {
        let preferredOrder = [characteristics.displayName, characteristics.attendeeNickname]
        return preferredOrder.first(where: { $0.isEmpty == false }).defaultingTo("?")
    }
    
    var alternateName: String? {
        if isNicknameEqualToDisplayName() {
            return nil
        } else {
            return characteristics.attendeeNickname
        }
    }
    
    var isAttendingOnThursday: Bool {
        characteristics.attendsOnThursday
    }
    
    var isAttendingOnFriday: Bool {
        characteristics.attendsOnFriday
    }
    
    var isAttendingOnSaturday: Bool {
        characteristics.attendsOnSaturday
    }
    
    var isAfterDark: Bool {
        characteristics.isAfterDark
    }
    
    init(
        eventBus: EventBus,
        dataStore: DataStore,
        imageCache: ImagesCache,
        mapCoordinateRender: MapCoordinateRender?,
        characteristics: DealerCharacteristics,
        shareableURLFactory: ShareableURLFactory,
        urlOpener: URLOpener?
    ) {
        self.eventBus = eventBus
        self.dataStore = dataStore
        self.imageCache = imageCache
        self.mapCoordinateRender = mapCoordinateRender
        self.characteristics = characteristics
        self.shareableURLFactory = shareableURLFactory
        self.urlOpener = urlOpener
        
        self.identifier = DealerIdentifier(characteristics.identifier)
    }
    
    var contentURL: URL {
        return shareableURLFactory.makeURL(for: identifier)
    }
    
    func openWebsite() {
        let links = characteristics.links
        guard let externalLink = links?.first(where: { $0.fragmentType == .WebExternal }) else { return }
        guard let url = URL(string: externalLink.target) else { return }
        
        urlOpener?.open(url)
    }
    
    func openTwitter() {
        guard characteristics.twitterHandle.isEmpty == false else { return }
        guard let url = URL(string: "https://twitter.com/") else { return }
        
        let twitterURL = url.appendingPathComponent(characteristics.twitterHandle)
        urlOpener?.open(twitterURL)
    }
    
    func openTelegram() {
        guard characteristics.telegramHandle.isEmpty == false else { return }
        guard let url = URL(string: "https://t.me/") else { return }
        
        let telegramURL = url.appendingPathComponent(characteristics.telegramHandle)
        urlOpener?.open(telegramURL)
    }
    
    func fetchExtendedDealerData(completionHandler: @escaping (ExtendedDealerData) -> Void) {
        var dealerMapLocationData: Data?
        if let (map, entry) = fetchMapData(), let mapData = imageCache.cachedImageData(for: map.imageIdentifier) {
            dealerMapLocationData = mapCoordinateRender?.render(
                x: entry.x,
                y: entry.y,
                radius: entry.tapRadius,
                onto: mapData
            )
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
        
        let extendedData = ExtendedDealerData(
            artistImagePNGData: artistImagePNGData,
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
            artPreviewCaption: convertEmptyStringsIntoNil(characteristics.artPreviewCaption)
        )
        
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
