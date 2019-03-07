//
//  CapturingScheduleEventComponent.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 13/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import Foundation

class CapturingScheduleEventComponent: ScheduleEventComponent {
    
    enum IconVisibility {
        case visible
        case hidden
        case unset
    }

    private(set) var capturedEventTitle: String?
    func setEventName(_ title: String) {
        capturedEventTitle = title
    }

    private(set) var capturedStartTime: String?
    func setEventStartTime(_ startTime: String) {
        capturedStartTime = startTime
    }

    private(set) var capturedEndTime: String?
    func setEventEndTime(_ endTime: String) {
        capturedEndTime = endTime
    }

    private(set) var capturedLocation: String?
    func setLocation(_ location: String) {
        capturedLocation = location
    }

    private(set) var capturedBannerGraphicPNGData: Data?
    func setBannerGraphicPNGData(_ graphicData: Data) {
        capturedBannerGraphicPNGData = graphicData
    }

    private(set) var didShowBanner = false
    func showBanner() {
        didShowBanner = true
    }

    private(set) var didHideBanner = false
    func hideBanner() {
        didHideBanner = true
    }

    private(set) var favouriteIconVisibility: IconVisibility = .unset
    func showFavouriteEventIndicator() {
        favouriteIconVisibility = .visible
    }

    func hideFavouriteEventIndicator() {
        favouriteIconVisibility = .hidden
    }

    private(set) var sponsorIconVisibility: IconVisibility = .unset
    func showSponsorEventIndicator() {
        sponsorIconVisibility = .visible
    }

    func hideSponsorEventIndicator() {
        sponsorIconVisibility = .hidden
    }

    private(set) var superSponsorIconVisibility: IconVisibility = .unset
    func showSuperSponsorOnlyEventIndicator() {
        superSponsorIconVisibility = .visible
    }

    func hideSuperSponsorOnlyEventIndicator() {
        superSponsorIconVisibility = .hidden
    }

    private(set) var artShowIconVisibility: IconVisibility = .unset
    func showArtShowEventIndicator() {
        artShowIconVisibility = .visible
    }

    func hideArtShowEventIndicator() {
        artShowIconVisibility = .hidden
    }

    private(set) var kageIconVisibility: IconVisibility = .unset
    func showKageEventIndicator() {
        kageIconVisibility = .visible
    }

    func hideKageEventIndicator() {
        kageIconVisibility = .hidden
    }

    private(set) var dealersDenIconVisibility: IconVisibility = .unset
    func showDealersDenEventIndicator() {
        dealersDenIconVisibility = .visible
    }

    func hideDealersDenEventIndicator() {
        dealersDenIconVisibility = .hidden
    }

    private(set) var mainStageIconVisibility: IconVisibility = .unset
    func showMainStageEventIndicator() {
        mainStageIconVisibility = .visible
    }

    func hideMainStageEventIndicator() {
        mainStageIconVisibility = .hidden
    }

    private(set) var photoshootIconVisibility: IconVisibility = .unset
    func showPhotoshootStageEventIndicator() {
        photoshootIconVisibility = .visible
    }

    private(set) var didHidePhotoshootStageEventIndicator = false
    func hidePhotoshootStageEventIndicator() {
        photoshootIconVisibility = .hidden
    }

}
