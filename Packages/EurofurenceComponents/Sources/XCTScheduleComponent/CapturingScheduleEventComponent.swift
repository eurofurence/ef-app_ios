import EurofurenceModel
import Foundation
import ScheduleComponent
import XCTComponentBase

public class CapturingScheduleEventComponent: ScheduleEventComponent {
    
    public init() {
        
    }
    
    public private(set) var capturedEventTitle: String?
    public func setEventName(_ title: String) {
        capturedEventTitle = title
    }

    public private(set) var capturedStartTime: String?
    public func setEventStartTime(_ startTime: String) {
        capturedStartTime = startTime
    }

    public private(set) var capturedEndTime: String?
    public func setEventEndTime(_ endTime: String) {
        capturedEndTime = endTime
    }

    public private(set) var capturedLocation: String?
    public func setLocation(_ location: String) {
        capturedLocation = location
    }

    public private(set) var capturedBannerGraphicPNGData: Data?
    public func setBannerGraphicPNGData(_ graphicData: Data) {
        capturedBannerGraphicPNGData = graphicData
    }

    public private(set) var didShowBanner = false
    public func showBanner() {
        didShowBanner = true
    }

    public private(set) var didHideBanner = false
    public func hideBanner() {
        didHideBanner = true
    }

    public private(set) var favouriteIconVisibility: VisibilityState = .unset
    public func showFavouriteEventIndicator() {
        favouriteIconVisibility = .visible
    }

    public func hideFavouriteEventIndicator() {
        favouriteIconVisibility = .hidden
    }

    public private(set) var sponsorIconVisibility: VisibilityState = .unset
    public func showSponsorEventIndicator() {
        sponsorIconVisibility = .visible
    }

    public func hideSponsorEventIndicator() {
        sponsorIconVisibility = .hidden
    }

    public private(set) var superSponsorIconVisibility: VisibilityState = .unset
    public func showSuperSponsorOnlyEventIndicator() {
        superSponsorIconVisibility = .visible
    }

    public func hideSuperSponsorOnlyEventIndicator() {
        superSponsorIconVisibility = .hidden
    }

    public private(set) var artShowIconVisibility: VisibilityState = .unset
    public func showArtShowEventIndicator() {
        artShowIconVisibility = .visible
    }

    public func hideArtShowEventIndicator() {
        artShowIconVisibility = .hidden
    }

    public private(set) var kageIconVisibility: VisibilityState = .unset
    public func showKageEventIndicator() {
        kageIconVisibility = .visible
    }

    public func hideKageEventIndicator() {
        kageIconVisibility = .hidden
    }

    public private(set) var dealersDenIconVisibility: VisibilityState = .unset
    public func showDealersDenEventIndicator() {
        dealersDenIconVisibility = .visible
    }

    public func hideDealersDenEventIndicator() {
        dealersDenIconVisibility = .hidden
    }

    public private(set) var mainStageIconVisibility: VisibilityState = .unset
    public func showMainStageEventIndicator() {
        mainStageIconVisibility = .visible
    }

    public func hideMainStageEventIndicator() {
        mainStageIconVisibility = .hidden
    }

    public private(set) var photoshootIconVisibility: VisibilityState = .unset
    public func showPhotoshootStageEventIndicator() {
        photoshootIconVisibility = .visible
    }

    public func hidePhotoshootStageEventIndicator() {
        photoshootIconVisibility = .hidden
    }
    
    public private(set) var faceMaskIconVisibility: VisibilityState = .unset
    public func showFaceMaskRequiredIndicator() {
        faceMaskIconVisibility = .visible
    }
    
    public func hideFaceMaskRequiredIndicator() {
        faceMaskIconVisibility = .hidden
    }

}
