//
//  FakeDealersService.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation

class FakeDealersService: DealersService {

    let index: FakeDealersIndex

    init(index: FakeDealersIndex = FakeDealersIndex()) {
        self.index = index
    }

    func makeDealersIndex() -> DealersIndex {
        return index
    }

    fileprivate var iconData = [Dealer.Identifier: Data]()
    func fetchIconPNGData(for identifier: Dealer.Identifier, completionHandler: @escaping (Data?) -> Void) {
        completionHandler(iconData[identifier])
    }

    fileprivate var fakedDealerData = [Dealer.Identifier: ExtendedDealerData]()
    func fetchExtendedDealerData(for dealer: Dealer.Identifier, completionHandler: @escaping (ExtendedDealerData) -> Void) {
        let data = fetchOrMakeExtendedDealerData(for: dealer)
        completionHandler(data)
    }

    private(set) var capturedIdentifierForOpeningWebsite: Dealer.Identifier?
    func openWebsite(for identifier: Dealer.Identifier) {
        capturedIdentifierForOpeningWebsite = identifier
    }

    private(set) var capturedIdentifierForOpeningTwitter: Dealer.Identifier?
    func openTwitter(for identifier: Dealer.Identifier) {
        capturedIdentifierForOpeningTwitter = identifier
    }

    private(set) var capturedIdentifierForOpeningTelegram: Dealer.Identifier?
    func openTelegram(for identifier: Dealer.Identifier) {
        capturedIdentifierForOpeningTelegram = identifier
    }

}

extension FakeDealersService {

    func stubIconPNGData(_ data: Data, for identifier: Dealer.Identifier) {
        iconData[identifier] = data
    }

    fileprivate func fetchOrMakeExtendedDealerData(for dealer: Dealer.Identifier) -> ExtendedDealerData {
        if let data = fakedDealerData[dealer] {
            return data
        }

        let data = ExtendedDealerData.random
        fakedDealerData[dealer] = data
        return data
    }

    func fakedDealerData(for identifier: Dealer.Identifier) -> ExtendedDealerData {
        return fetchOrMakeExtendedDealerData(for: identifier)
    }

    func stub(_ data: ExtendedDealerData, for identifier: Dealer.Identifier) {
        fakedDealerData[identifier] = data
    }

}
