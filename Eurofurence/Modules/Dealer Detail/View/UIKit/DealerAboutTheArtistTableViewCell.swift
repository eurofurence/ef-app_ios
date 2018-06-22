//
//  DealerAboutTheArtistTableViewCell.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 22/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

class DealerAboutTheArtistTableViewCell: UITableViewCell, DealerAboutTheArtistComponent {

    // MARK: Properties

    @IBOutlet weak var componentTitleLabel: UILabel!
    @IBOutlet weak var artistDescriptionLabel: UILabel!

    // MARK: DealerAboutTheArtistComponent

    func setAboutTheArtistTitle(_ title: String) {
        componentTitleLabel.text = title
    }

    func setArtistDescription(_ artistDescription: String) {
        artistDescriptionLabel.text = artistDescription
    }

}
