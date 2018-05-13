//
//  RelativeTimeIntervalCountdownFormatter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 13/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol RelativeTimeIntervalCountdownFormatter {

    func relativeString(from timeInterval: TimeInterval) -> String

}
