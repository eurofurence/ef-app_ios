//
//  DealersInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 18/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol DealersInteractor {

    func makeDealersViewModel(completionHandler: @escaping (DealersViewModel) -> Void)
    func makeDealersSearchViewModel(completionHandler: @escaping (DealersSearchViewModel) -> Void)

}
