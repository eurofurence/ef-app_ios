//
//  AppWindowWireframe.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 06/11/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit.UIViewController
import UIKit.UIWindow

struct AppWindowWireframe: WindowWireframe {

    static var shared: AppWindowWireframe = {
        let window = UIApplication.shared.delegate!.window!!
        return AppWindowWireframe(window: window)
    }()

    var window: UIWindow

    func setRoot(_ viewController: UIViewController) {
        window.rootViewController = viewController
    }

}
