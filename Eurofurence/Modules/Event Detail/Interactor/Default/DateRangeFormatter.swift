//
//  DateRangeFormatter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 21/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol DateRangeFormatter {

    func string(from startDate: Date, to endDate: Date) -> String

}
