//
//  PhoneNewsSceneFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 06/11/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit.UIStoryboard

struct PhoneNewsSceneFactory: NewsSceneFactory {

    func makeNewsScene() -> UIViewController & NewsScene {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: "NewsTableView") as! NewsTableViewController
    }

}
