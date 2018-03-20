//
//  AppURLOpener.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 20/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation.NSURL
import UIKit.UIApplication

struct AppURLOpener: URLOpener {

    func open(_ url: URL) {
        UIApplication.shared.openURL(url)
    }

}
