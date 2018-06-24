//
//  CollectThemAllSceneFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

protocol CollectThemAllSceneFactory {

    func makeCollectThemAllScene() -> UIViewController & CollectThemAllScene

}
