//
//  ScreenshotAssistant.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 26/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

#if TAKING_SCREENSHOTS
import SimulatorStatusMagic
#endif

class ScreenshotAssistant {

    static func prepare() {
#if TAKING_SCREENSHOTS
        SDStatusBarManager.sharedInstance().enableOverrides()
#endif
    }

}
