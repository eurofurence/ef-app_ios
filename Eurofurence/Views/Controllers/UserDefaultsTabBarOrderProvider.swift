//
//  UserDefaultsTabBarOrderProvider.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

struct UserDefaultsTabBarOrderProvider: TabBarOrderProviding {
	static let tabBarOrderKey = "TabBarOrderProviding.tabBarOrder"

	var tabBarOrder: [String] {
		return userDefaults.array(forKey: UserDefaultsTabBarOrderProvider.tabBarOrderKey) as? [String] ?? []
	}

	let userDefaults: UserDefaults

	init(userDefaults: UserDefaults) {
		self.userDefaults = userDefaults
	}

	func setTabBarOrder(_ vcIdentifiers: [String]) {
		userDefaults.set(vcIdentifiers, forKey: UserDefaultsTabBarOrderProvider.tabBarOrderKey)
	}
}
