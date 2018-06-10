//
//  EventDetailBannerTableViewCell.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 31/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

class EventDetailBannerTableViewCell: UITableViewCell, EventGraphicComponent {

    // MARK: IBOutlets

    @IBOutlet weak var bannerImageView: UIImageView!

    // MARK: EventGraphicComponent

    func setPNGGraphicData(_ pngGraphicData: Data) {
        let image = UIImage(data: pngGraphicData)
        bannerImageView.image = image

        if let image = image {
            applyAspectRatioConstraint(image.size)
        }
    }

    // MARK: Framing Workaround

    private var aspectRatioConstraint: NSLayoutConstraint?
    private func applyAspectRatioConstraint(_ size: CGSize) {
        if let aspectRatioConstraint = aspectRatioConstraint {
            bannerImageView.removeConstraint(aspectRatioConstraint)
        }

        let constraint = NSLayoutConstraint(item: bannerImageView,
                                            attribute: .height,
                                            relatedBy: .equal,
                                            toItem: bannerImageView,
                                            attribute: .width,
                                            multiplier: size.height / size.width,
                                            constant: 0)
        bannerImageView.addConstraint(constraint)
        aspectRatioConstraint = constraint
    }

}
