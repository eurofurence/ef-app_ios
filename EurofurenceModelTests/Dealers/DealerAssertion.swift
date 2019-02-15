//
//  DealerAssertion.swift
//  EurofurenceModelTests
//
//  Created by Thomas Sherwood on 14/02/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import EurofurenceModel

class DealerAssertion: EntityAssertion {

    func assertDealer(_ dealer: DealerProtocol?, characterisedBy characteristic: DealerCharacteristics) {
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
