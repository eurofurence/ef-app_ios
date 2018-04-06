//
//  TargetRouter.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import UIKit

protocol TargetRouter {
	func show(target: RoutingTarget)
}

struct RoutingTarget {
	var viewControllerIdentifier: String
	var navigationControllerIdentifier: String
	var payload: [String: Any]?

	init(target viewControllerIdentifier: String,
	                 on navigationControllerIdentifier: String,
	                 payload: [String: Any]? = nil) {
		self.viewControllerIdentifier = viewControllerIdentifier
		self.navigationControllerIdentifier = navigationControllerIdentifier
		self.payload = payload
	}
}
