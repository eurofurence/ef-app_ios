//
//  FakeDealersService.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import Foundation

class FakeDealersService: DealersService {
    
    let index: FakeDealersIndex
    
    init(index: FakeDealersIndex = FakeDealersIndex()) {
        self.index = index
    }
    
    func makeDealersIndex() -> DealersIndex {
        return index
    }
    
    fileprivate var iconData = [Dealer2.Identifier : Data]()
    func fetchIconPNGData(for identifier: Dealer2.Identifier, completionHandler: @escaping (Data?) -> Void) {
        completionHandler(iconData[identifier])
    }
    
    fileprivate var fakedDealerData = [Dealer2.Identifier : ExtendedDealerData]()
    func fetchExtendedDealerData(for dealer: Dealer2.Identifier, completionHandler: @escaping (ExtendedDealerData) -> Void) {
        let data = fetchOrMakeExtendedDealerData(for: dealer)
        completionHandler(data)
    }
    
    private(set) var capturedIdentifierForOpeningWebsite: Dealer2.Identifier?
    func openWebsite(for identifier: Dealer2.Identifier) {
        capturedIdentifierForOpeningWebsite = identifier
    }
    
    private(set) var capturedIdentifierForOpeningTwitter: Dealer2.Identifier?
    func openTwitter(for identifier: Dealer2.Identifier) {
        capturedIdentifierForOpeningTwitter = identifier
    }
    
    private(set) var capturedIdentifierForOpeningTelegram: Dealer2.Identifier?
    func openTelegram(for identifier: Dealer2.Identifier) {
        capturedIdentifierForOpeningTelegram = identifier
    }
    
}

extension FakeDealersService {
    
    func stubIconPNGData(_ data: Data, for identifier: Dealer2.Identifier) {
        iconData[identifier] = data
    }
    
    fileprivate func fetchOrMakeExtendedDealerData(for dealer: Dealer2.Identifier) -> ExtendedDealerData {
        if let data = fakedDealerData[dealer] {
            return data
        }
        
        let data = ExtendedDealerData.random
        fakedDealerData[dealer] = data
        return data
    }
    
    func fakedDealerData(for identifier: Dealer2.Identifier) -> ExtendedDealerData {
        return fetchOrMakeExtendedDealerData(for: identifier)
    }
    
    func stub(_ data: ExtendedDealerData, for identifier: Dealer2.Identifier) {
        fakedDealerData[identifier] = data
    }
    
}
