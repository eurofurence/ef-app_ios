import EurofurenceModel
import TestUtilities

class DayAssertion: Assertion {

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
            assertDay(day, characterisedBy: characteristic)
        }
    }

    func assertDay(_ day: Day?, characterisedBy characteristic: ConferenceDayCharacteristics) {
        guard let day = day else {
            fail(message: "Expected day: \(characteristic)")
            return
        }

        assert(day.date, isEqualTo: characteristic.date)
        assert(day.identifier, isEqualTo: characteristic.identifier)
    }

}
