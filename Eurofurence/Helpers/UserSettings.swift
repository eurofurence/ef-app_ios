//
//  UserSettings.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

enum UserSettings: String {
    case UpdateOnStart
    case AutomaticRefreshOnMobile
    case AutomaticRefreshOnMobileAsked
    case RefreshTimer
    case RefreshInBackground
    case NotifyOnAnnouncement
    case RefreshInBackgroundOnMobile
	case DebugTimeOffset
	case DebugSettingsEnabled

    func defaultValue<T>() -> T {
        switch self {
        case .UpdateOnStart:
            return true as! T
        case .AutomaticRefreshOnMobile:
            return false as! T
        case .AutomaticRefreshOnMobileAsked:
            return false as! T
        case .RefreshTimer:
            return (15 * 60) as! T
        case .RefreshInBackground:
            return false as! T
        case .NotifyOnAnnouncement:
			return true as! T
		case .RefreshInBackgroundOnMobile:
			return true as! T
		case .DebugTimeOffset:
			return 0.0 as! T
		case .DebugSettingsEnabled:
			return false as! T
        }
	}

	func currentValueOrDefault<T>() -> T {
		let defaults = UserDefaults.standard
		if let value = defaults.object(forKey: self.rawValue) {
			return value as! T
		} else {
			return self.defaultValue()
		}
	}

	func currentValue<T>() -> T? {
		let defaults = UserDefaults.standard
		return defaults.object(forKey: self.rawValue) as? T
	}

	@discardableResult
    func setValue<T>(_ value: T?) -> T? {
        let defaults = UserDefaults.standard
		let oldValue: T? = self.currentValue()
        defaults.set(value, forKey: self.rawValue)
        return oldValue
    }
}
