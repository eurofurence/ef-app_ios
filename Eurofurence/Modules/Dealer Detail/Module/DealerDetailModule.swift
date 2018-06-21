//
//  DealerDetailModule.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 20/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

struct DealerDetailModule: DealerDetailModuleProviding {

    var dealerDetailSceneFactory: DealerDetailSceneFactory

    func makeDealerDetailModule(for dealer: Dealer2.Identifier) -> UIViewController {
        return dealerDetailSceneFactory.makeDealerDetailScene()
    }

}
