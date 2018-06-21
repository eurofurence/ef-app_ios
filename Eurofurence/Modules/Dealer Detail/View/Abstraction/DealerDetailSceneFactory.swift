//
//  DealerDetailSceneFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 21/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

protocol DealerDetailSceneFactory {

    func makeDealerDetailScene() -> UIViewController & DealerDetailScene

}
