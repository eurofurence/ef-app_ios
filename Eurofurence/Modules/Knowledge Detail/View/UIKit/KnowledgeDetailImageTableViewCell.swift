//
//  KnowledgeDetailImageTableViewCell.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 01/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

class KnowledgeDetailImageTableViewCell: UITableViewCell, KnowledgeEntryImageScene {

    // MARK: Properties

    @IBOutlet weak var entryImageView: UIImageView!

    // MARK: KnowledgeEntryImageScene

    func showImagePNGData(_ data: Data) {
        entryImageView.image = UIImage(data: data)
    }

}
