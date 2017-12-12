//
//  MessageDetailSceneFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 12/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit.UIViewController

protocol MessageDetailSceneFactory {

    func makeMessageDetailScene() -> UIViewController & MessageDetailScene

}
