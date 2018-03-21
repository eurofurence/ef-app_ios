//
//  LinkTableViewCell.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 13/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

class LinkTableViewCell: UITableViewCell, LinkScene {

    // MARK: IBOutlets

    @IBOutlet weak var linkButton: UIButton!

    // MARK: LinkScene

    func setLinkName(_ linkName: String) {
        linkButton.setTitle(linkName, for: .normal)
    }

}
