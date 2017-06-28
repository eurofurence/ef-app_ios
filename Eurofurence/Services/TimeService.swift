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
class TimeService {
	let currentTime = MutableProperty(Date())
	
	/// Changes the offset with respect to current local time.
	var offset: TimeInterval {
		get {
			return _offset
		}
		set(offset) {
			_offset = offset
			if timer != nil {
				tick()
			}
		}
	}

	private var lastTime = Date()
	private var _offset = TimeInterval(0)
	private var timer: Timer? = nil

	init() {
		resume()
	}

	/**
	Sends a tick to all observers of currentTime.
	*/
	@objc
	func tick() {
		currentTime.swap(Date().addingTimeInterval(_offset))
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
}
