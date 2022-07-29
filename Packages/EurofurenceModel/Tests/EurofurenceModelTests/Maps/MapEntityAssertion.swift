import EurofurenceModel
import TestUtilities

class MapEntityAssertion: Assertion {

    func assertMaps(_ maps: [Map], characterisedBy characteristics: [MapCharacteristics]) {
        guard maps.count == characteristics.count else {
            fail(message: "Expected \(characteristics.count) maps, got \(maps.count)")
            return
        }

        let orderedCharacteristics = characteristics.sorted(by: { $0.order < $1.order })
        for (idx, map) in maps.enumerated() {
            let characteristic = orderedCharacteristics[idx]

            assert(characteristic.identifier, isEqualTo: map.identifier.rawValue)
            assert(characteristic.mapDescription, isEqualTo: map.location)
        }
    }

}
