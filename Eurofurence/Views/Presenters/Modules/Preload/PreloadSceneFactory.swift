//
//  PreloadSceneFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 27/09/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit.UIViewController

protocol PreloadSceneFactory {

    func makePreloadScene() -> UIViewController & SplashScene

}
