//
//  DealerDetailModuleProviding.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 20/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import UIKit

protocol DealerDetailModuleProviding {

    func makeDealerDetailModule(for dealer: Dealer.Identifier) -> UIViewController

}
