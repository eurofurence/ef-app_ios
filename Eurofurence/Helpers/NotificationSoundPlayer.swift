//
//  NotificationSoundPlayer.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import AudioToolbox

class NotificationSoundPlayer {
	static let shared = NotificationSoundPlayer()
	private static let soundsLibraryDirectoryName = "Sounds"
	private static let noneSoundName = "none.caf"

	private let baseDirectory = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
	private var soundsLibraryDirectory: URL
	private var soundIds: [String : SystemSoundID] = [:]

	init() {
		soundsLibraryDirectory = baseDirectory.appendingPathComponent(
			NotificationSoundPlayer.soundsLibraryDirectoryName,
			isDirectory: true)
	}

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

		guard let soundUrl = Bundle.main.url(forResource: soundName, withExtension: nil) else {
			return nil
		}
		var soundId = SystemSoundID(0)
		AudioServicesCreateSystemSoundID(soundUrl as CFURL, &soundId)
		soundIds[soundName] = soundId

		return soundId
	}

	func copyToSoundsLibrary(_ soundName: String?, targetName: String) throws {
		try checkSoundsLibraryDirectory()

		let targetUrl = soundsLibraryDirectory.appendingPathComponent(targetName,
		                                                              isDirectory: false)
		if FileManager.default.fileExists(atPath: targetUrl.path) {
			try FileManager.default.removeItem(at: targetUrl)
		}

		guard let soundUrl = Bundle.main.url(
				forResource: soundName ?? NotificationSoundPlayer.noneSoundName,
				withExtension: nil) else { return }
		try FileManager.default.copyItem(at: soundUrl, to: targetUrl)
	}

	private func checkSoundsLibraryDirectory() throws {
		if !FileManager.default.fileExists(atPath: soundsLibraryDirectory.path) {
			try FileManager.default.createDirectory(at: soundsLibraryDirectory, withIntermediateDirectories: true)
			try soundsLibraryDirectory.setExcludedFromBackup(true)
		}
	}
}

enum NotificationSound: Int {
	case None = 0
	case Classic = 1
	case Themed = 2
}
