import Combine
import ComponentBase
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
    
    private var favouritedEventIndicator: UIView!
    private var sponsorEventIndicator: UIView!
    private var superSponsorEventIndicator: UIView!
    private var artShowIndicatorView: UIView!
    private var kageBugIndicatorView: UIView!
    private var kageWineGlassIndicatorView: UIView!
    private var dealersDenIndicatorView: UIView!
    private var mainStageIndicatorView: UIView!
    private var photoshootIndicatorView: UIView!
    private var faceMaskIndicatorView: UIView!
    
    @IBOutlet private weak var verticalIconsStack: UIStackView!
    @IBOutlet private weak var eventBannerImageView: UIImageView!

    // MARK: Overrides

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        favouritedEventIndicator = IconView(icon: .favourite)
        favouritedEventIndicator.accessibilityIdentifier = "Event_IsFavourite"
        
        sponsorEventIndicator = IconView(icon: .sponsor)
        sponsorEventIndicator.accessibilityIdentifier = "Event_IsSponsorOnly"
        
        superSponsorEventIndicator = IconView(icon: .superSponsor)
        superSponsorEventIndicator.accessibilityIdentifier = "Event_IsSuperSponsorOnly"
        
        artShowIndicatorView = IconView(icon: .artshow)
        artShowIndicatorView.accessibilityIdentifier = "Event_IsArtShow"
        
        kageBugIndicatorView = IconView(icon: .bug)
        kageBugIndicatorView.accessibilityIdentifier = "Event_KageBug"
        
        kageWineGlassIndicatorView = IconView(icon: .wine)
        kageWineGlassIndicatorView.accessibilityIdentifier = "Event_KageWineGlass"
        
        dealersDenIndicatorView = IconView(icon: .dealersDen)
        dealersDenIndicatorView.accessibilityIdentifier = "Event_IsDealersDen"
        
        mainStageIndicatorView = IconView(icon: .mainStage)
        mainStageIndicatorView.accessibilityIdentifier = "Event_IsMainStage"
        
        photoshootIndicatorView = IconView(icon: .photoshoot)
        photoshootIndicatorView.accessibilityIdentifier = "Event_IsPhotoshoot"
        
        faceMaskIndicatorView = IconView(icon: .faceMaskRequired)
        faceMaskIndicatorView.accessibilityIdentifier = "Event_IsFaceMaskRequired"
        
        let icons: [UIView] = [
            favouritedEventIndicator,
            sponsorEventIndicator,
            superSponsorEventIndicator,
            artShowIndicatorView,
            kageBugIndicatorView,
            kageWineGlassIndicatorView,
            dealersDenIndicatorView,
            mainStageIndicatorView,
            photoshootIndicatorView,
            faceMaskIndicatorView
        ]
        
        for icon in icons.reversed() {
            verticalIconsStack.insertArrangedSubview(icon, at: 0)
        }
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
    
    public func showFaceMaskRequiredIndicator() {
        faceMaskIndicatorView.isHidden = false
    }
    
    public func hideFaceMaskRequiredIndicator() {
        faceMaskIndicatorView.isHidden = true
    }

}
