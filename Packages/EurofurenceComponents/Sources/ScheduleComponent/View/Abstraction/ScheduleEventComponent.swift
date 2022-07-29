import Foundation

public protocol ScheduleEventComponent {

    func setEventName(_ title: String)
    func setEventStartTime(_ startTime: String)
    func setEventEndTime(_ endTime: String)
    func setLocation(_ location: String)
    func setBannerGraphicPNGData(_ graphicData: Data)
    func showBanner()
    func hideBanner()
    func showFavouriteEventIndicator()
    func hideFavouriteEventIndicator()
    func showSponsorEventIndicator()
    func hideSponsorEventIndicator()
    func showSuperSponsorOnlyEventIndicator()
    func hideSuperSponsorOnlyEventIndicator()
    func showArtShowEventIndicator()
    func hideArtShowEventIndicator()
    func showKageEventIndicator()
    func hideKageEventIndicator()
    func showDealersDenEventIndicator()
    func hideDealersDenEventIndicator()
    func showMainStageEventIndicator()
    func hideMainStageEventIndicator()
    func showPhotoshootStageEventIndicator()
    func hidePhotoshootStageEventIndicator()
    func showFaceMaskRequiredIndicator()
    func hideFaceMaskRequiredIndicator()

}
