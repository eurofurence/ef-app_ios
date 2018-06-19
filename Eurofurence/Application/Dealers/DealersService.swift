//
//  DealersService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 19/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol DealersService {

    func add(_ dealersServiceObserver: DealersServiceObserver)

}

protocol DealersServiceObserver {

    func dealersDidChange(_ dealers: [Dealer2])

}
