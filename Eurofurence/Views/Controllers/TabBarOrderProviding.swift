//
//  TabBarOrderProviding.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

protocol TabBarOrderProviding {
	var tabBarOrder: [String] { get }
	func setTabBarOrder(_ vcIdentifiers: [String])
}
