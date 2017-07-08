//
//  ReplaceViewControllersSegue.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

class ReplaceViewControllersSegue: UIStoryboardSegue {

    override func perform() {
        let navigationController = source.navigationController
        navigationController?.setViewControllers([destination], animated: true)
    }

}
