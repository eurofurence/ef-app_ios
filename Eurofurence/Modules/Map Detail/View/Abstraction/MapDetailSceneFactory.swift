//
//  MapDetailSceneFactory.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 27/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

protocol MapDetailSceneFactory {

    func makeMapDetailScene() -> UIViewController & MapDetailScene

}
