import UIKit

public class EventTableViewCell: UITableViewCell, ScheduleEventComponent {
    
    override public class func registerNib(in tableView: UITableView) {
        registerNib(in: tableView, bundle: .module)
    }

    // MARK: IBOutlets

    @IBOutlet private weak var eventNameLabel: UILabel! {
        didSet {
            eventNameLabel.accessibilityIdentifier = "Event_Title"
        }
    }
    
    @IBOutlet private weak var locationLabel: UILabel! {
        didSet {
            locationLabel.accessibilityIdentifier = "Event_Location"
        }
    }
    
    @IBOutlet private weak var startTimeLabel: UILabel! {
        didSet {
            startTimeLabel.accessibilityIdentifier = "Event_StartTime"
        }
    }
    
    @IBOutlet private weak var endTimeLabel: UILabel! {
        didSet {
            endTimeLabel.accessibilityIdentifier = "Event_EndTime"
        }
    }
    
    @IBOutlet private weak var favouritedEventIndicator: UIView!
    @IBOutlet private weak var eventBannerImageView: UIImageView!
    @IBOutlet private weak var sponsorEventIndicator: UILabel!
    @IBOutlet private weak var superSponsorEventIndicator: UILabel!
    @IBOutlet private weak var artShowIndicatorView: UILabel!
    @IBOutlet private weak var kageBugIndicatorView: UILabel!
    @IBOutlet private weak var kageWineGlassIndicatorView: UILabel!
    @IBOutlet private weak var dealersDenIndicatorView: UILabel!
    @IBOutlet private weak var mainStageIndicatorView: UILabel!
    @IBOutlet private weak var photoshootIndicatorView: UILabel!

    // MARK: Overrides

    override public func awakeFromNib() {
        super.awakeFromNib()

        artShowIndicatorView.text = "\u{f03e}"
        kageBugIndicatorView.text = "\u{f188}"
        kageWineGlassIndicatorView.text = "\u{f000}"
        dealersDenIndicatorView.text = "\u{f07a}"
        mainStageIndicatorView.text = "\u{f069}"
        photoshootIndicatorView.text = "\u{f030}"
    }

    // MARK: ScheduleEventComponent

    public func setEventStartTime(_ startTime: String) {
        startTimeLabel.text = startTime
    }

    public func setEventEndTime(_ endTime: String) {
        endTimeLabel.text = endTime
    }

    public func setEventName(_ eventName: String) {
        eventNameLabel.text = eventName
    }

    public func setLocation(_ location: String) {
        locationLabel.text = location
    }

    public func setBannerGraphicPNGData(_ graphicData: Data) {
        eventBannerImageView.image = UIImage(data: graphicData)
    }

    public func showBanner() {
        eventBannerImageView.isHidden = false
    }

    public func hideBanner() {
        eventBannerImageView.isHidden = true
        eventBannerImageView.image = nil
    }

    public func showFavouriteEventIndicator() {
        favouritedEventIndicator.isHidden = false
    }

    public func hideFavouriteEventIndicator() {
        favouritedEventIndicator.isHidden = true
    }

    public func showSponsorEventIndicator() {
        sponsorEventIndicator.isHidden = false
    }

    public func hideSponsorEventIndicator() {
        sponsorEventIndicator.isHidden = true
    }

    public func showSuperSponsorOnlyEventIndicator() {
        superSponsorEventIndicator.isHidden = false
    }

    public func hideSuperSponsorOnlyEventIndicator() {
        superSponsorEventIndicator.isHidden = true
    }

    public func showArtShowEventIndicator() {
        artShowIndicatorView.isHidden = false
    }

    public func hideArtShowEventIndicator() {
        artShowIndicatorView.isHidden = true
    }

    public func showKageEventIndicator() {
        kageBugIndicatorView.isHidden = false
        kageWineGlassIndicatorView.isHidden = false
    }

    public func hideKageEventIndicator() {
        kageBugIndicatorView.isHidden = true
        kageWineGlassIndicatorView.isHidden = true
    }

    public func showDealersDenEventIndicator() {
        dealersDenIndicatorView.isHidden = false
    }

    public func hideDealersDenEventIndicator() {
        dealersDenIndicatorView.isHidden = true
    }

    public func showMainStageEventIndicator() {
        mainStageIndicatorView.isHidden = false
    }

    public func hideMainStageEventIndicator() {
        mainStageIndicatorView.isHidden = true
    }

    public func showPhotoshootStageEventIndicator() {
        photoshootIndicatorView.isHidden = false
    }

    public func hidePhotoshootStageEventIndicator() {
        photoshootIndicatorView.isHidden = true
    }

}
