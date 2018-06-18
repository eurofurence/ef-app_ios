//
//  DealersViewModel.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 18/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol DealersViewModel {

    func setDelegate(_ delegate: DealersViewModelDelegate)

}

protocol DealersViewModelDelegate {

    func dealerGroupsDidChange(_ groups: [DealersGroupViewModel])

}
