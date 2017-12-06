//
//  PhoneNewsSceneFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 06/11/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit.UIStoryboard

struct PhoneNewsSceneFactory: NewsSceneFactory {

    private let storyboard = UIStoryboard(name: "News", bundle: .main)

    func makeNewsScene() -> UIViewController & NewsScene {
        return storyboard.instantiateViewController(withIdentifier: "NewsViewController") as! NewsViewController
    }

}
