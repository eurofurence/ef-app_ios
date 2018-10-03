//
//  DateDistanceCalculator.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 10/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol DateDistanceCalculator {

    func calculateDays(between first: Date, and second: Date) -> Int

}
