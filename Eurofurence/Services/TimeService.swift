//
//  TimeService.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import ReactiveSwift

/**
Service which allows the app to travel through time.
(Strictly for debugging purposes!)
*/
class TimeService: NSObject {
	let currentTime = MutableProperty(Date())

	/// Represents the offset with respect to current local time
	let offset: MutableProperty<TimeInterval> = MutableProperty(0.0)

	private var lastTime = Date()
	private var timer: Timer?
	private let disposables = CompositeDisposable()

	override init() {
		super.init()

        UserDefaults.standard.addObserver(self, forKeyPath: UserSettings.DebugTimeOffset.rawValue, options: NSKeyValueObservingOptions.new, context: nil)
        UserDefaults.standard.addObserver(self, forKeyPath: UserSettings.DebugTimeOffsetIntoFuture.rawValue, options: NSKeyValueObservingOptions.new, context: nil)

        offset.swap((UserSettings.DebugTimeOffsetIntoFuture.currentValueOrDefault() ? 1 : -1) * UserSettings.DebugTimeOffset.currentValueOrDefault())
		resume()

		disposables += offset.signal.observeValues({ [unowned self] _ in
			if self.timer != nil {
				self.tick()
			}
		})
	}

	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if let change = change, let firstChange = change.first, let newOffset = firstChange.value as? TimeInterval, keyPath == UserSettings.DebugTimeOffset.rawValue {
            offset.swap((UserSettings.DebugTimeOffsetIntoFuture.currentValueOrDefault() ? 1 : -1) * newOffset)
        } else if let change = change, let firstChange = change.first, let isOffsetIntoFuture = firstChange.value as? Bool, keyPath == UserSettings.DebugTimeOffsetIntoFuture.rawValue {
            offset.swap((isOffsetIntoFuture ? 1 : -1) * abs(offset.value))
        }
	}

	/**
	Sends a tick to all observers of currentTime.
	*/
	@objc
	func tick() {
		currentTime.swap(Date().addingTimeInterval(offset.value))
	}

	/**
	Halts the generation of new ticks until resume is called.
	*/
	func stop() {
		timer?.invalidate()
		timer = nil
	}

	/**
	Resumes sending ticks at one second intervals.
	*/
	func resume() {
		if timer == nil {
			timer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(TimeService.tick), userInfo: nil, repeats: true)
		}
	}

	deinit {
		disposables.dispose()
	}
}
