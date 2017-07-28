//
//  NotificationSoundPlayer.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import AudioToolbox

class NotificationSoundPlayer {
	static let shared = NotificationSoundPlayer()

	private var soundIds: [String : SystemSoundID] = [:]

	func playSound(for soundName: String?) {
		guard let soundId = getSystemSoundId(for: soundName) else {
			return
		}
		AudioServicesPlayAlertSound(soundId)
	}

	func getSystemSoundId(for soundName: String?) -> SystemSoundID? {
		guard let soundName = soundName else {
			return nil
		}

		if let soundId = soundIds[soundName] {
			return soundId
		}

		guard let filePath = Bundle.main.path(forResource: soundName, ofType: nil) else {
			return nil
		}
		let soundUrl = NSURL(fileURLWithPath: filePath)
		var soundId = SystemSoundID(0)
		AudioServicesCreateSystemSoundID(soundUrl, &soundId)
		soundIds[soundName] = soundId

		return soundId
	}
}

enum NotificationSound: Int {
	case None = 0
	case Classic = 1
	case Themed = 2
}
