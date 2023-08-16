import ComponentBase
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

    private func appendSummary(_ data: ExtendedDealerData, components: inout [DetailViewModelComponent]) {
        let summary = DealerDetailSummaryViewModel(
            artistImagePNGData: data.artistImagePNGData,
            title: data.preferredName,
            subtitle: data.alternateName,
            categories: data.categories.joined(separator: ", "),
            shortDescription: data.dealerShortDescription,
            website: data.websiteName,
            twitterHandle: data.twitterUsername,
            telegramHandle: data.telegramUsername
        )
        let summaryComponent = SummaryComponent(summary: summary)
        components.append(summaryComponent)
    }
    
    init(
        dealer: Dealer,
        data: ExtendedDealerData,
        dealerIdentifier: DealerIdentifier,
        dealersService: DealersService,
        shareService: ShareService
    ) {
        self.dealer = dealer
        self.dealerIdentifier = dealerIdentifier
        self.dealersService = dealersService
        self.shareService = shareService

        appendSummary(data, components: &components)
        appendLocationAndAvailability(data, components: &components)
        appendAboutTheArtist(data, components: &components)
        appendAboutTheArt(data, components: &components)
    }
    
    private func appendLocationAndAvailability(
        _ data: ExtendedDealerData,
        components: inout [DetailViewModelComponent]
    ) {
        var afterDarkMessage: String?
        if data.isAfterDark {
            afterDarkMessage = NSLocalizedString(
                "LocatedWithinAfterDarkDen",
                bundle: .module,
                comment: "Short sentence describing that the dealer is located within the after-dark dealers den"
            )
        }
        
        let limitedAvailabilityMessage = prepareLimitedAvailabilityMessage(data)
        
        let locationAndAvailabilityTitle = NSLocalizedString(
            "LocationAndAvailability",
            bundle: .module,
            comment: "Heading in the dealer view explaining their location, convention availability and their AD status"
        )
        
        let locationAndAvailability = DealerDetailLocationAndAvailabilityViewModel(
            title: locationAndAvailabilityTitle,
            mapPNGGraphicData: data.dealersDenMapLocationGraphicPNGData,
            limitedAvailabilityWarning: limitedAvailabilityMessage,
            locatedInAfterDarkDealersDenMessage: afterDarkMessage
        )
        
        if let locationAndAvailabilityComponent = LocationAndAvailabilityComponent(
            locationAndAvailability: locationAndAvailability
        ) {
            components.append(locationAndAvailabilityComponent)
        }
    }
    
    private func appendAboutTheArtist(_ data: ExtendedDealerData, components: inout [DetailViewModelComponent]) {
        let aboutTheArtistText: String
        if let text = data.aboutTheArtist {
            aboutTheArtistText = text
        } else {
            aboutTheArtistText = NSLocalizedString(
                "AboutTheArtistPlaceholder",
                bundle: .module,
                comment: "Placeholder text in the Dealer screen when the artist didn't provide a custom description"
            )
        }
        
        let aboutTheArtistTitle = NSLocalizedString(
            "AboutTheArtist",
            bundle: .module,
            comment: "Title for section in the Dealer Details screen showing the description provided by the artist"
        )
        
        let aboutTheArtist = DealerDetailAboutTheArtistViewModel(title: aboutTheArtistTitle,
                                                                 artistDescription: aboutTheArtistText)
        let aboutTheArtistComponent = AboutTheArtistComponent(aboutTheArtist: aboutTheArtist)
        components.append(aboutTheArtistComponent)
    }
    
    private func appendAboutTheArt(_ data: ExtendedDealerData, components: inout [DetailViewModelComponent]) {
        let aboutTheArtTitle = NSLocalizedString(
            "AboutTheArt",
            bundle: .module,
            comment: "Title for section in the Dealer Details screen showing the sample art provided by the dealer"
        )
        
        let aboutTheArt = DealerDetailAboutTheArtViewModel(title: aboutTheArtTitle,
                                                           aboutTheArt: data.aboutTheArt,
                                                           artPreviewImagePNGData: data.artPreviewImagePNGData,
                                                           artPreviewCaption: data.artPreviewCaption)
        if let aboutTheArtComponent = AboutTheArtComponent(aboutTheArt: aboutTheArt) {
            components.append(aboutTheArtComponent)
        }
    }

    private func prepareLimitedAvailabilityMessage(_ data: ExtendedDealerData) -> String? {
        let format = NSLocalizedString(
            "OnlyPresentOnSpecificDaysFormat",
            bundle: .module,
            comment: "Text displayed with the days during the convention a dealer is present for, e.g. 'Thursday'"
        )
        
        if data.isAttendingOnThursday && data.isAttendingOnFriday && data.isAttendingOnSaturday {
            return nil
        }
        
        var days = [String]()

        // TODO: Improve model (and backend API) to support arbitrary weekdays
        /*
         EF27 starts on Sunday instead of Wednesday, thus DD is open Monday to Wednesday instead of Thursday to Saturday:
         Thursday -> Monday
         Friday   -> Tuesday
         Saturday -> Wednesday
         */
        if data.isAttendingOnThursday {
            // TODO: EF27 weekdays
            // days.append("Thursday")
            days.append("Monday")
        }
        if data.isAttendingOnFriday {
            // TODO: EF27 weekdays
            // days.append("Friday")
            days.append("Tuesday")
        }
        if data.isAttendingOnSaturday {
            // TODO: EF27 weekdays
            // days.append("Saturday")
            days.append("Wednesday")
        }

        if days.isEmpty {
            return nil
        } else {        
            return String.localizedStringWithFormat(format, days.joined(separator: ", "))
        }
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
        shareService.share(DealerActivityItemSource(dealer: dealer), sender: sender)
    }

}
