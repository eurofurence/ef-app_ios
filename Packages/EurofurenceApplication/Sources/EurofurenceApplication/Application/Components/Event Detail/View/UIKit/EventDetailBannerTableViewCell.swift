import ComponentBase
import UIKit

class EventDetailBannerTableViewCell: UITableViewCell, EventGraphicComponent {

    // MARK: IBOutlets

    @IBOutlet private weak var bannerImageView: UIImageView!
    
    // MARK: Overrides
    
    override func layoutSubviews() {
        super.layoutSubviews()
        hideSeperator()
    }

    // MARK: EventGraphicComponent

    func setPNGGraphicData(_ pngGraphicData: Data) {
        bannerImageView.image = UIImage(data: pngGraphicData)
    }

}
