import UIKit

class EventTableViewCell: UITableViewCell, ScheduleEventComponent {

    // MARK: IBOutlets

    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var favouritedEventIndicator: UIView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var eventBannerImageView: UIImageView!
    @IBOutlet weak var sponsorEventIndicator: UILabel!
    @IBOutlet weak var superSponsorEventIndicator: UILabel!
    @IBOutlet weak var artShowIndicatorView: UILabel!
    @IBOutlet weak var kageBugIndicatorView: UILabel!
    @IBOutlet weak var kageWineGlassIndicatorView: UILabel!
    @IBOutlet weak var dealersDenIndicatorView: UILabel!
    @IBOutlet weak var mainStageIndicatorView: UILabel!
    @IBOutlet weak var photoshootIndicatorView: UILabel!

    // MARK: Overrides

    override func awakeFromNib() {
        super.awakeFromNib()

        let applyIconColour: (UILabel?) -> Void = { $0?.textColor = .pantone330U }
        let nonFavouriteIndicators = [sponsorEventIndicator,
                                      superSponsorEventIndicator,
                                      artShowIndicatorView,
                                      kageBugIndicatorView,
                                      kageWineGlassIndicatorView,
                                      dealersDenIndicatorView,
                                      mainStageIndicatorView,
                                      photoshootIndicatorView]
        nonFavouriteIndicators.forEach(applyIconColour)

        artShowIndicatorView.text = "\u{f03e}"
        kageBugIndicatorView.text = "\u{f188}"
        kageWineGlassIndicatorView.text = "\u{f000}"
        dealersDenIndicatorView.text = "\u{f07a}"
        mainStageIndicatorView.text = "\u{f069}"
        photoshootIndicatorView.text = "\u{f030}"
    }

    // MARK: ScheduleEventComponent

    func setEventStartTime(_ startTime: String) {
        startTimeLabel.text = startTime
    }

    func setEventEndTime(_ endTime: String) {
        endTimeLabel.text = endTime
    }

    func setEventName(_ eventName: String) {
        eventNameLabel.text = eventName
    }

    func setLocation(_ location: String) {
        locationLabel.text = location
    }

    func setBannerGraphicPNGData(_ graphicData: Data) {
        eventBannerImageView.image = UIImage(data: graphicData)
    }

    func showBanner() {
        eventBannerImageView.isHidden = false
    }

    func hideBanner() {
        eventBannerImageView.isHidden = true
        eventBannerImageView.image = nil
    }

    func showFavouriteEventIndicator() {
        favouritedEventIndicator.isHidden = false
    }

    func hideFavouriteEventIndicator() {
        favouritedEventIndicator.isHidden = true
    }

    func showSponsorEventIndicator() {
        sponsorEventIndicator.isHidden = false
    }

    func hideSponsorEventIndicator() {
        sponsorEventIndicator.isHidden = true
    }

    func showSuperSponsorOnlyEventIndicator() {
        superSponsorEventIndicator.isHidden = false
    }

    func hideSuperSponsorOnlyEventIndicator() {
        superSponsorEventIndicator.isHidden = true
    }

    func showArtShowEventIndicator() {
        artShowIndicatorView.isHidden = false
    }

    func hideArtShowEventIndicator() {
        artShowIndicatorView.isHidden = true
    }

    func showKageEventIndicator() {
        kageBugIndicatorView.isHidden = false
        kageWineGlassIndicatorView.isHidden = false
    }

    func hideKageEventIndicator() {
        kageBugIndicatorView.isHidden = true
        kageWineGlassIndicatorView.isHidden = true
    }

    func showDealersDenEventIndicator() {
        dealersDenIndicatorView.isHidden = false
    }

    func hideDealersDenEventIndicator() {
        dealersDenIndicatorView.isHidden = true
    }

    func showMainStageEventIndicator() {
        mainStageIndicatorView.isHidden = false
    }

    func hideMainStageEventIndicator() {
        mainStageIndicatorView.isHidden = true
    }

    func showPhotoshootStageEventIndicator() {
        photoshootIndicatorView.isHidden = false
    }

    func hidePhotoshootStageEventIndicator() {
        photoshootIndicatorView.isHidden = true
    }

}
