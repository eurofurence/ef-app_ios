//
//  KnowledgeListSectionHeaderTableViewCell.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 13/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

class KnowledgeListSectionHeaderTableViewCell: UITableViewCell, KnowledgeGroupScene {

    // MARK: IBOutlets

    @IBOutlet weak var knowledgeGroupTitleLabel: UILabel!
//    @IBOutlet weak var knowledgeGroupIconImageView: UIImageView!
    @IBOutlet weak var knowledgeGroupDescriptionLabel: UILabel!

    // MARK: KnowledgeGroupHeaderScene

    func setKnowledgeGroupTitle(_ title: String) {
        knowledgeGroupTitleLabel.text = title
    }

    func setKnowledgeGroupIcon(_ icon: UIImage) {
//        knowledgeGroupIconImageView.image = icon
    }

    func setKnowledgeGroupDescription(_ groupDescription: String) {
        knowledgeGroupDescriptionLabel.text = groupDescription
    }

}
