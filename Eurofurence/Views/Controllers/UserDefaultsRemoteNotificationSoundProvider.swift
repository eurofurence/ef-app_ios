//
//  UserDefaultsRemoteNotificationSoundProvider.swift
//  Eurofurence
//
//  Created by Dominik Schöner on 29.07.17.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

struct UserDefaultsRemoteNotificationSoundProvider: RemoteNotificationSoundProviding {
	static let remoteNotificationSoundKey = "RemoteNotificationSoundProviding.remoteNotificationSound"
	
	var remoteNotificationSound: NotificationSound {
		return NotificationSound(rawValue: userDefaults.integer(forKey: UserDefaultsRemoteNotificationSoundProvider.remoteNotificationSoundKey)) ?? NotificationSound.Themed
	}
	
	private let userDefaults: UserDefaults
	
	init(userDefaults: UserDefaults) {
		self.userDefaults = userDefaults
		userDefaults.register(defaults: [
			UserDefaultsRemoteNotificationSoundProvider.remoteNotificationSoundKey: NotificationSound.Themed.rawValue
			])
	}
	
	func setRemoteNotificationSound(_ remoteNotificationSound: NotificationSound) {
		userDefaults.set(remoteNotificationSound.rawValue, forKey: UserDefaultsRemoteNotificationSoundProvider.remoteNotificationSoundKey)
		let soundName = getRemoteNotificationSoundName()
		let targetName = UserDefaultsRemoteNotificationSoundProvider.getRemoteNotificationDefaultSoundName()
		do {
			try NotificationSoundPlayer.shared.copyToSoundsLibrary(soundName, targetName: targetName)
		} catch let error {
			print("Failed to copy requested sound \(String(describing:soundName)) to Library/Sounds: \(String(describing: error))")
		}
	}
}
