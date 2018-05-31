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
        bannerImageView.image = UIImage(data: pngGraphicData)
    }

}
