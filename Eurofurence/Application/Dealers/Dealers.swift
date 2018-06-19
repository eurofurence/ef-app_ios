//
//  Dealers.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 19/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

class Dealers: DealersService {

    class Index: DealersIndex {

        func setDelegate(_ delegate: DealersIndexDelegate) {
            delegate.alphabetisedDealersDidChange(to: [])
        }

    }

    func makeDealersIndex() -> DealersIndex {
        return Index()
    }

    func fetchIconPNGData(for identifier: Dealer2.Identifier, completionHandler: @escaping (Data?) -> Void) {

    }

}
