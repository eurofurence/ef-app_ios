import EurofurenceModel
import TestUtilities

class DealerAssertion: Assertion {
    
    func assertDealers(_ dealers: [Dealer]?, characterisedBy characteristics: [DealerCharacteristics]) {
        guard let dealers = dealers else {
            fail(message: "Asserting against nil dealers")
            return
        }
        
        guard dealers.count == characteristics.count else {
            fail(message: "Differing amount of expected/actual dealers")
            return
        }
        
        for (idx, dealer) in dealers.enumerated() {
            let characteristic = characteristics[idx]
            assertDealer(dealer, characterisedBy: characteristic)
        }
    }

    func assertDealer(_ dealer: Dealer?, characterisedBy characteristic: DealerCharacteristics) {
        guard let dealer = dealer else {
            fail(message: "Expected dealer \(characteristic)")
            return
        }

        let alternateName: String? = characteristic.attendeeNickname == characteristic.displayName ? nil : characteristic.attendeeNickname

        assert(dealer.identifier, isEqualTo: DealerIdentifier(rawValue: characteristic.identifier))
        assert(dealer.preferredName, isEqualTo: characteristic.displayName)
        assert(dealer.alternateName, isEqualTo: alternateName)
        assert(dealer.isAttendingOnThursday, isEqualTo: characteristic.attendsOnThursday)
        assert(dealer.isAttendingOnFriday, isEqualTo: characteristic.attendsOnFriday)
        assert(dealer.isAttendingOnSaturday, isEqualTo: characteristic.attendsOnSaturday)
        assert(dealer.isAfterDark, isEqualTo: characteristic.isAfterDark)
    }

}
