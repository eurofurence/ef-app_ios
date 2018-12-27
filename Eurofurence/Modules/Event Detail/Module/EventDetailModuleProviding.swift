//
//  EventDetailModuleProviding.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 17/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import UIKit.UIViewController

protocol EventDetailModuleProviding {

    func makeEventDetailModule(for event: Event.Identifier) -> UIViewController

}
