//
//  DefaultDealerDetailInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 22/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation

class DefaultDealerDetailInteractor: DealerDetailInteractor {

    private let dealersService: DealersService

    convenience init() {
        self.init(dealersService: SharedModel.instance.services.dealers)
    }

    init(dealersService: DealersService) {
        self.dealersService = dealersService
    }

    func makeDealerDetailViewModel(for identifier: DealerIdentifier,
                                   completionHandler: @escaping (DealerDetailViewModel) -> Void) {
        let dealer = dealersService.fetchDealer(for: identifier)
        dealer?.fetchExtendedDealerData(completionHandler: { (data) in
            completionHandler(DefaultDealerDetailViewModel(data: data, dealerIdentifier: identifier, dealersService: self.dealersService))
        })
    }

}
