//
//  MapCollectionViewCell.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

class MapCollectionViewCell: UICollectionViewCell, MapComponent {

    // MARK: Properties

    @IBOutlet weak var mapPreviewImageView: UIImageView!
    @IBOutlet weak var mapNameLabel: UILabel!

    // MARK: Overrides

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 14
    }

    // MARK: MapComponent

    func setMapName(_ mapName: String) {
        mapNameLabel.text = mapName
    }

    func setMapPreviewImagePNGData(_ data: Data) {
        mapPreviewImageView.image = UIImage(data: data)
    }

}
