//
//  ShortFormDayAndTimeFormatter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 17/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol ShortFormDayAndTimeFormatter {

    func dayAndHoursString(from date: Date) -> String

}
