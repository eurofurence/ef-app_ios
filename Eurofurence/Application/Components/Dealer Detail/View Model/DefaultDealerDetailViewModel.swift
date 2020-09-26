import EurofurenceModel
import Foundation

private protocol DetailViewModelComponent {

    func describe(to visitor: DealerDetailViewModelVisitor)

}

struct DefaultDealerDetailViewModel: DealerDetailViewModel {

    struct SummaryComponent: DetailViewModelComponent {

        var summary: DealerDetailSummaryViewModel

        func describe(to visitor: DealerDetailViewModelVisitor) {
            visitor.visit(summary)
        }

    }

    struct LocationAndAvailabilityComponent: DetailViewModelComponent {

        var locationAndAvailability: DealerDetailLocationAndAvailabilityViewModel

        init?(locationAndAvailability: DealerDetailLocationAndAvailabilityViewModel) {
            guard locationAndAvailability.mapPNGGraphicData != nil ||
                locationAndAvailability.limitedAvailabilityWarning != nil ||
                locationAndAvailability.locatedInAfterDarkDealersDenMessage != nil else {
                    return nil
            }

            self.locationAndAvailability = locationAndAvailability
        }

        func describe(to visitor: DealerDetailViewModelVisitor) {
            visitor.visit(locationAndAvailability)
        }

    }

    struct AboutTheArtistComponent: DetailViewModelComponent {

        var aboutTheArtist: DealerDetailAboutTheArtistViewModel

        func describe(to visitor: DealerDetailViewModelVisitor) {
            visitor.visit(aboutTheArtist)
        }

    }

    struct AboutTheArtComponent: DetailViewModelComponent {

        var aboutTheArt: DealerDetailAboutTheArtViewModel

        init?(aboutTheArt: DealerDetailAboutTheArtViewModel) {
            guard aboutTheArt.aboutTheArt != nil ||
                aboutTheArt.artPreviewImagePNGData != nil ||
                aboutTheArt.artPreviewImagePNGData != nil else {
                    return nil
            }

            self.aboutTheArt = aboutTheArt
        }

        func describe(to visitor: DealerDetailViewModelVisitor) {
            visitor.visit(aboutTheArt)
        }

    }

    private var components = [DetailViewModelComponent]()
    private let dealer: Dealer
    private let dealerIdentifier: DealerIdentifier
    private let dealersService: DealersService
    private let shareService: ShareService

    init(dealer: Dealer,
         data: ExtendedDealerData,
         dealerIdentifier: DealerIdentifier,
         dealersService: DealersService,
         shareService: ShareService) {
        self.dealer = dealer
        self.dealerIdentifier = dealerIdentifier
        self.dealersService = dealersService
        self.shareService = shareService

        let summary = DealerDetailSummaryViewModel(artistImagePNGData: data.artistImagePNGData,
                                                   title: data.preferredName,
                                                   subtitle: data.alternateName,
                                                   categories: data.categories.joined(separator: ", "),
                                                   shortDescription: data.dealerShortDescription,
                                                   website: data.websiteName,
                                                   twitterHandle: data.twitterUsername,
                                                   telegramHandle: data.telegramUsername)
        let summaryComponent = SummaryComponent(summary: summary)
        components.append(summaryComponent)

        var afterDarkMessage: String?
        if data.isAfterDark {
            afterDarkMessage = .locatedWithinAfterDarkDen
        }

        let limitedAvailabilityMessage = prepareLimitedAvailabilityMessage(data)

        let locationAndAvailability = DealerDetailLocationAndAvailabilityViewModel(title: .locationAndAvailability,
                                                                                   mapPNGGraphicData: data.dealersDenMapLocationGraphicPNGData,
                                                                                   limitedAvailabilityWarning: limitedAvailabilityMessage,
                                                                                   locatedInAfterDarkDealersDenMessage: afterDarkMessage)
        if let locationAndAvailabilityComponent = LocationAndAvailabilityComponent(locationAndAvailability: locationAndAvailability) {
            components.append(locationAndAvailabilityComponent)
        }

        var aboutTheArtistText: String = .aboutTheArtistPlaceholder
        if let text = data.aboutTheArtist {
            aboutTheArtistText = text
        }

        let aboutTheArtist = DealerDetailAboutTheArtistViewModel(title: .aboutTheArtist,
                                                                 artistDescription: aboutTheArtistText)
        let aboutTheArtistComponent = AboutTheArtistComponent(aboutTheArtist: aboutTheArtist)
        components.append(aboutTheArtistComponent)

        let aboutTheArt = DealerDetailAboutTheArtViewModel(title: .aboutTheArt,
                                                           aboutTheArt: data.aboutTheArt,
                                                           artPreviewImagePNGData: data.artPreviewImagePNGData,
                                                           artPreviewCaption: data.artPreviewCaption)
        if let aboutTheArtComponent = AboutTheArtComponent(aboutTheArt: aboutTheArt) {
            components.append(aboutTheArtComponent)
        }
    }

    private func prepareLimitedAvailabilityMessage(_ data: ExtendedDealerData) -> String? {
        var limitedAvailabilityMessage: String?
        if !data.isAttendingOnThursday {
            limitedAvailabilityMessage = String.formattedOnlyPresentOnDaysString(["Friday", "Saturday"])
        }

        if !data.isAttendingOnFriday {
            limitedAvailabilityMessage = String.formattedOnlyPresentOnDaysString(["Thursday", "Saturday"])
        }

        if !data.isAttendingOnSaturday {
            limitedAvailabilityMessage = String.formattedOnlyPresentOnDaysString(["Thursday", "Friday"])
        }

        if !data.isAttendingOnFriday && !data.isAttendingOnSaturday {
            limitedAvailabilityMessage = String.formattedOnlyPresentOnDaysString(["Thursday"])
        }

        if !data.isAttendingOnThursday && !data.isAttendingOnSaturday {
            limitedAvailabilityMessage = String.formattedOnlyPresentOnDaysString(["Friday"])
        }

        if !data.isAttendingOnThursday && !data.isAttendingOnFriday {
            limitedAvailabilityMessage = String.formattedOnlyPresentOnDaysString(["Saturday"])
        }

        return limitedAvailabilityMessage
    }

    var numberOfComponents: Int {
        return components.count
    }

    func describeComponent(at index: Int, to visitor: DealerDetailViewModelVisitor) {
        guard index < components.count else { return }
        components[index].describe(to: visitor)
    }

    func openWebsite() {
        dealer.openWebsite()
    }

    func openTwitter() {
        dealer.openTwitter()
    }

    func openTelegram() {
        dealer.openTelegram()
    }
    
    func shareDealer(_ sender: Any) {
        shareService.share(dealer, sender: sender)
    }

}
