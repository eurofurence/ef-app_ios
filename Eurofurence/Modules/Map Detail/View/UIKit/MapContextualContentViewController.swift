//
//  MapContextualContentViewController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 06/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

class MapContextualContentViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!

    func setContextualContent(_ content: String) {
        titleLabel.text = content
        preferredContentSize = view.systemLayoutSizeFitting(UILayoutFittingExpandedSize)
    }

}
