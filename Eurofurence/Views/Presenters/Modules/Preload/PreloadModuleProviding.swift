//
//  PreloadModuleProviding.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 02/10/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

protocol PreloadModuleProviding {

    func makePreloadModule(_ delegate: PreloadModuleDelegate) -> UIViewController

}
