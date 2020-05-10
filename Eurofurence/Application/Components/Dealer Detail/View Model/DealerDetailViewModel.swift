import Foundation

public protocol DealerDetailViewModel {

    var numberOfComponents: Int { get }
    func describeComponent(at index: Int, to visitor: DealerDetailViewModelVisitor)

    func openWebsite()
    func openTwitter()
    func openTelegram()
    func shareDealer(_ sender: Any)

}

public protocol DealerDetailViewModelVisitor {

    func visit(_ summary: DealerDetailSummaryViewModel)
    func visit(_ location: DealerDetailLocationAndAvailabilityViewModel)
    func visit(_ aboutTheArtist: DealerDetailAboutTheArtistViewModel)
    func visit(_ aboutTheArt: DealerDetailAboutTheArtViewModel)

}

public struct DealerDetailSummaryViewModel: Equatable {

    public var artistImagePNGData: Data?
    public var title: String
    public var subtitle: String?
    public var categories: String
    public var shortDescription: String?
    public var website: String?
    public var twitterHandle: String?
    public var telegramHandle: String?
    
    public init(
        artistImagePNGData: Data?,
        title: String,
        subtitle: String?,
        categories: String,
        shortDescription: String?,
        website: String?,
        twitterHandle: String?,
        telegramHandle: String?
    ) {
        self.artistImagePNGData = artistImagePNGData
        self.title = title
        self.subtitle = subtitle
        self.categories = categories
        self.shortDescription = shortDescription
        self.website = website
        self.twitterHandle = twitterHandle
        self.telegramHandle = telegramHandle
    }

}

public struct DealerDetailLocationAndAvailabilityViewModel: Equatable {

    public var title: String
    public var mapPNGGraphicData: Data?
    public var limitedAvailabilityWarning: String?
    public var locatedInAfterDarkDealersDenMessage: String?
    
    public init(
        title: String,
        mapPNGGraphicData: Data?,
        limitedAvailabilityWarning: String?,
        locatedInAfterDarkDealersDenMessage: String?
    ) {
        self.title = title
        self.mapPNGGraphicData = mapPNGGraphicData
        self.limitedAvailabilityWarning = limitedAvailabilityWarning
        self.locatedInAfterDarkDealersDenMessage = locatedInAfterDarkDealersDenMessage
    }

}

public struct DealerDetailAboutTheArtistViewModel: Equatable {

    public var title: String
    public var artistDescription: String
    
    public init(title: String, artistDescription: String) {
        self.title = title
        self.artistDescription = artistDescription
    }

}

public struct DealerDetailAboutTheArtViewModel: Equatable {

    public var title: String
    public var aboutTheArt: String?
    public var artPreviewImagePNGData: Data?
    public var artPreviewCaption: String?
    
    public init(
        title: String,
        aboutTheArt: String?,
        artPreviewImagePNGData: Data?,
        artPreviewCaption: String?
    ) {
        self.title = title
        self.aboutTheArt = aboutTheArt
        self.artPreviewImagePNGData = artPreviewImagePNGData
        self.artPreviewCaption = artPreviewCaption
    }

}
