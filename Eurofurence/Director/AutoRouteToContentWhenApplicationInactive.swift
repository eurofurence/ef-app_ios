//
//  AutoRouteToContentWhenApplicationInactive.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 11/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

struct AutoRouteToContentWhenApplicationInactive: AutoRouteToContentStateProviding {

    var autoRoute: Bool {
        return UIApplication.shared.applicationState == .inactive
    }

}
