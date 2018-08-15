//
//  ApplicationAppStateProviding.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

struct ApplicationAppStateProviding: AppStateProviding {

    var isAppActive: Bool {
        return UIApplication.shared.applicationState == .active
    }

}
