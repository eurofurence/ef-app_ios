import Combine
import UIKit

public class EventTableViewCell: UITableViewCell, ScheduleEventComponent {
    
    // TODO: Needs encapsulating!
    public var subscriptions = Set<AnyCancellable>()
    
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
    
    @IBOutlet private weak var favouritedEventIndicator: UIView! {
        didSet {
            favouritedEventIndicator.accessibilityIdentifier = "Event_IsFavourite"
        }
    }
    
    @IBOutlet private weak var sponsorEventIndicator: UIView! {
        didSet {
            sponsorEventIndicator.accessibilityIdentifier = "Event_IsSponsorOnly"
            sponsorEventIndicator.tintColor = .efTintColor
        }
    }
    
    @IBOutlet private weak var superSponsorEventIndicator: UIView! {
        didSet {
            superSponsorEventIndicator.accessibilityIdentifier = "Event_IsSuperSponsorOnly"
            superSponsorEventIndicator.tintColor = .efTintColor
        }
    }
    
    @IBOutlet private weak var artShowIndicatorView: UIView! {
        didSet {
            artShowIndicatorView.accessibilityIdentifier = "Event_IsArtShow"
            artShowIndicatorView.tintColor = .efTintColor
        }
    }
    
    @IBOutlet private weak var kageBugIndicatorView: UILabel! {
        didSet {
            kageBugIndicatorView.accessibilityIdentifier = "Event_KageBug"
        }
    }
    
    @IBOutlet private weak var kageWineGlassIndicatorView: UILabel! {
        didSet {
            kageWineGlassIndicatorView.accessibilityIdentifier = "Event_KageWineGlass"
        }
    }
    
    @IBOutlet private weak var dealersDenIndicatorView: UIView! {
        didSet {
            dealersDenIndicatorView.accessibilityIdentifier = "Event_IsDealersDen"
            dealersDenIndicatorView.tintColor = .efTintColor
        }
    }
    
    @IBOutlet private weak var mainStageIndicatorView: UIView! {
        didSet {
            mainStageIndicatorView.accessibilityIdentifier = "Event_IsMainStage"
            mainStageIndicatorView.tintColor = .efTintColor
        }
    }
    
    @IBOutlet private weak var photoshootIndicatorView: UIView! {
        didSet {
            photoshootIndicatorView.accessibilityIdentifier = "Event_IsPhotoshoot"
            photoshootIndicatorView.tintColor = .efTintColor
        }
    }
    
    @IBOutlet private weak var eventBannerImageView: UIImageView!

    // MARK: Overrides

    override public func awakeFromNib() {
        super.awakeFromNib()

        kageBugIndicatorView.text = "\u{f188}"
        kageWineGlassIndicatorView.text = "\u{f000}"
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
