//
//  DealerDetailViewModel.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 21/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol DealerDetailViewModel {

    var numberOfComponents: Int { get }
    func describeComponent(at index: Int, to visitor: DealerDetailViewModelVisitor)

    func openWebsite()
    func openTwitter()
    func openTelegram()

}

protocol DealerDetailViewModelVisitor {

    func visit(_ summary: DealerDetailSummaryViewModel)
    func visit(_ location: DealerDetailLocationAndAvailabilityViewModel)
    func visit(_ aboutTheArtist: DealerDetailAboutTheArtistViewModel)
    func visit(_ aboutTheArt: DealerDetailAboutTheArtViewModel)

}

struct DealerDetailSummaryViewModel: Equatable {

    var artistImagePNGData: Data?
    var title: String
    var subtitle: String?
    var categories: String
    var shortDescription: String?
    var website: String?
    var twitterHandle: String?
    var telegramHandle: String?

}

struct DealerDetailLocationAndAvailabilityViewModel: Equatable {

    var title: String
    var mapPNGGraphicData: Data?
    var limitedAvailabilityWarning: String?
    var locatedInAfterDarkDealersDenMessage: String?

}

struct DealerDetailAboutTheArtistViewModel: Equatable {

    var title: String
    var artistDescription: String

}

struct DealerDetailAboutTheArtViewModel: Equatable {

    var title: String
    var aboutTheArt: String?

}
