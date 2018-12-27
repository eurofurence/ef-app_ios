//
//  DefaultDealerDetailInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 22/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation

private protocol DetailViewModelComponent {

    func describe(to visitor: DealerDetailViewModelVisitor)

}

class DefaultDealerDetailInteractor: DealerDetailInteractor {

    private struct ViewModel: DealerDetailViewModel {

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
        private let dealerIdentifier: Dealer.Identifier
        private let dealersService: DealersService

        init(data: ExtendedDealerData, dealerIdentifier: Dealer.Identifier, dealersService: DealersService) {
            self.dealerIdentifier = dealerIdentifier
            self.dealersService = dealersService

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

        var numberOfComponents: Int {
            return components.count
        }

        func describeComponent(at index: Int, to visitor: DealerDetailViewModelVisitor) {
            guard index < components.count else { return }
            components[index].describe(to: visitor)
        }

        func openWebsite() {
            dealersService.openWebsite(for: dealerIdentifier)
        }

        func openTwitter() {
            dealersService.openTwitter(for: dealerIdentifier)
        }

        func openTelegram() {
            dealersService.openTelegram(for: dealerIdentifier)
        }

    }

    private let dealersService: DealersService

    convenience init() {
        self.init(dealersService: EurofurenceApplication.shared)
    }

    init(dealersService: DealersService) {
        self.dealersService = dealersService
    }

    func makeDealerDetailViewModel(for identifier: Dealer.Identifier,
                                   completionHandler: @escaping (DealerDetailViewModel) -> Void) {
        dealersService.fetchExtendedDealerData(for: identifier) { (data) in
            completionHandler(ViewModel(data: data, dealerIdentifier: identifier, dealersService: self.dealersService))
        }
    }

}
