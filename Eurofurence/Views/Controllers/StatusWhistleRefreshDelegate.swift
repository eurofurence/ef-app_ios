//
//  StatusWhistleRefreshDelegate.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Whisper
import UIKit
import ReactiveSwift

class StatusWhistleRefreshDelegate: DataStoreRefreshDelegate {
	static let successColor = UIColor.init(red: 0.00, green: 0.75, blue: 0.00, alpha: 1.0)

	func dataStoreRefreshDidBegin(_ lastSync: Date?) {}

	func dataStoreRefreshDidFinish() {
		let murmur = Murmur(title: "Refresh complete", backgroundColor: StatusWhistleRefreshDelegate.successColor, titleColor: .white)
		Whisper.show(whistle: murmur, action: .show(1.5))
	}

	func dataStoreRefreshDidFailWithError(_ error: Error) {
		var errorSource: String = "data"
		if let error = error as? ActionError<NSError> {
			switch error {
			case let .producerFailed(error):
				if error.domain == ImageServiceError.errorDomain {
					errorSource = "images"
				}
			default:
				break
			}
		}

		let murmur = Murmur(title: "Failed to download \(errorSource) from server", backgroundColor: .red, titleColor: .white)
		Whisper.show(whistle: murmur, action: .show(3.0))
	}

	func dataStoreRefreshDidProduceProgress(_ progress: Progress) {}
}
