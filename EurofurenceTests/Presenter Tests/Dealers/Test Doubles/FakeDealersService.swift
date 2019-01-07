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

    fileprivate var iconData = [DealerIdentifier: Data]()
    func fetchIconPNGData(for identifier: DealerIdentifier, completionHandler: @escaping (Data?) -> Void) {
        completionHandler(iconData[identifier])
    }

    fileprivate var fakedDealerData = [DealerIdentifier: ExtendedDealerData]()
    func fetchExtendedDealerData(for dealer: DealerIdentifier, completionHandler: @escaping (ExtendedDealerData) -> Void) {
        let data = fetchOrMakeExtendedDealerData(for: dealer)
        completionHandler(data)
    }

    private(set) var capturedIdentifierForOpeningWebsite: DealerIdentifier?
    func openWebsite(for identifier: DealerIdentifier) {
        capturedIdentifierForOpeningWebsite = identifier
    }

    private(set) var capturedIdentifierForOpeningTwitter: DealerIdentifier?
    func openTwitter(for identifier: DealerIdentifier) {
        capturedIdentifierForOpeningTwitter = identifier
    }

    private(set) var capturedIdentifierForOpeningTelegram: DealerIdentifier?
    func openTelegram(for identifier: DealerIdentifier) {
        capturedIdentifierForOpeningTelegram = identifier
    }

}

extension FakeDealersService {

    func stubIconPNGData(_ data: Data, for identifier: DealerIdentifier) {
        iconData[identifier] = data
    }

    fileprivate func fetchOrMakeExtendedDealerData(for dealer: DealerIdentifier) -> ExtendedDealerData {
        if let data = fakedDealerData[dealer] {
            return data
        }

        let data = ExtendedDealerData.random
        fakedDealerData[dealer] = data
        return data
    }

    func fakedDealerData(for identifier: DealerIdentifier) -> ExtendedDealerData {
        return fetchOrMakeExtendedDealerData(for: identifier)
    }

    func stub(_ data: ExtendedDealerData, for identifier: DealerIdentifier) {
        fakedDealerData[identifier] = data
    }

}
