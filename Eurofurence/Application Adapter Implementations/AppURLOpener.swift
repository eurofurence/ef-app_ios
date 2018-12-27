//
//  AppURLOpener.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 20/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation.NSURL
import UIKit.UIApplication

struct AppURLOpener: URLOpener {

    func canOpen(_ url: URL) -> Bool {
        return UIApplication.shared.canOpenURL(url)
    }

    func open(_ url: URL) {
        UIApplication.shared.open(url)
    }

}
