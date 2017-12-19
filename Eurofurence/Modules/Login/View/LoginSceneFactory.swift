//
//  LoginSceneFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/11/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit.UIViewController

protocol LoginSceneFactory {

    func makeLoginScene() -> UIViewController & LoginScene

}
