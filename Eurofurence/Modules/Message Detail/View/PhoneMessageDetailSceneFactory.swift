//
//  PhoneMessageDetailSceneFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 12/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit.UIStoryboard
import UIKit.UIViewController

struct PhoneMessageDetailSceneFactory: MessageDetailSceneFactory {

    private let storyboard = UIStoryboard(name: "MessageDetail", bundle: .main)

    func makeMessageDetailScene() -> UIViewController & MessageDetailScene {
        return storyboard.instantiate(MessageDetailViewController.self)
    }

}
