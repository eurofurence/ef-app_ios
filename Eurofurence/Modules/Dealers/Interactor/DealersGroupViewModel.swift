//
//  DealersGroupViewModel.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 18/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct DealersGroupViewModel {

    var dealers: [DealerViewModel]

}

protocol DealerViewModel {

    var title: String { get }
    var subtitle: String { get }
    var isPresentForAllDays: Bool { get }

    func fetchIconPNGData(completionHandler: @escaping (Data?) -> Void)

}
