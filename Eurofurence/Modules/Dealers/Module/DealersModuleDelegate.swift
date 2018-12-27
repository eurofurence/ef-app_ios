//
//  DealersModuleDelegate.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 20/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation

protocol DealersModuleDelegate {

    func dealersModuleDidSelectDealer(identifier: Dealer.Identifier)

}
