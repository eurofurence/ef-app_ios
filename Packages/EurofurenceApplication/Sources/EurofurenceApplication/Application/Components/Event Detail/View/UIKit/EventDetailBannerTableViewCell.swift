import UIKit

class EventDetailBannerTableViewCell: UITableViewCell, EventGraphicComponent {

    // MARK: IBOutlets

    @IBOutlet private weak var bannerImageView: UIImageView!

    // MARK: EventGraphicComponent

    func setPNGGraphicData(_ pngGraphicData: Data) {
        bannerImageView.image = UIImage(data: pngGraphicData)
    }

}
