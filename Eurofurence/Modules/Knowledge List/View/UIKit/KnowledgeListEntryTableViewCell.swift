//
//  KnowledgeListEntryTableViewCell.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 14/02/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

class KnowledgeListEntryTableViewCell: UITableViewCell, KnowledgeGroupEntryScene {

    // MARK: KnowledgeGroupEntryScene

    func setKnowledgeEntryTitle(_ title: String) {
        textLabel?.text = title
    }

}
