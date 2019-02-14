//
//  DayAssertion.swift
//  EurofurenceModelTests
//
//  Created by Thomas Sherwood on 14/02/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import EurofurenceModel

class DayAssertion: EntityAssertion {

    func assertDays(_ days: [Day], characterisedBy characteristics: [ConferenceDayCharacteristics]) {
        guard days.count == characteristics.count else {
            fail(message: "Differing amount of expected/actual days")
            return
        }

        let orderedCharacteristics = characteristics.sorted { (first, second) -> Bool in
            return first.date < second.date
        }

        for (idx, day) in days.enumerated() {
            let characteristic = orderedCharacteristics[idx]

            assert(day.date, isEqualTo: characteristic.date)
        }
    }

}
