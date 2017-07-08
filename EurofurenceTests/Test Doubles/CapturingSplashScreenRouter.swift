//
//  CapturingSplashScreenRouter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingSplashScreenRouter: SplashScreenRouter {

    private(set) var wasToldToShowSplashScreen = false
    func showSplashScreen() {
        wasToldToShowSplashScreen = true
    }
    
}
