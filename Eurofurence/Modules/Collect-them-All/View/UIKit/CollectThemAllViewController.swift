//
//  CollectThemAllViewController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

class CollectThemAllViewController: UIViewController, CollectThemAllScene {

    // MARK: CollectThemAllScene

    func setShortCollectThemAllTitle(_ shortTitle: String) {
        tabBarItem.title = shortTitle
    }

}
