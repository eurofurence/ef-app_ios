//
//  Environment.swift
//  Eurofurence
//
//  Created by Dominik Schöner on 2017-06-19.
//  Copyright © 2017 Dominik Schöner. All rights reserved.
//


import Foundation
import Dip

enum Environment: String, DependencyTagConvertible {
	case Production
	case Development
}