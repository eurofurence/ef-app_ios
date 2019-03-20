//
//  CocoaTouchHapticEngine.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 18/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

struct CocoaTouchHapticEngine: HapticEngine {

    func playSelectionHaptic() {
        UISelectionFeedbackGenerator().selectionChanged()
    }

}
