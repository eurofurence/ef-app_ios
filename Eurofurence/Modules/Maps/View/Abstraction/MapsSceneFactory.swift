//
//  MapsSceneFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

protocol MapsSceneFactory {

    func makeMapsScene() -> UIViewController & MapsScene

}
