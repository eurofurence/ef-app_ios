//
//  UserSettings.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

enum UserSettings<T>: String {
    case UpdateOnStart
    case AutomaticRefreshOnMobile
    case AutomaticRefreshOnMobileAsked
    case RefreshTimer
    case RefreshInBackground
    case NotifyOnAnnouncement
    case RefreshInBackgroundOnMobile
    
    func defaultValue()->T {
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
        }
    }
    
    func currentValue()->T {
        let defaults = UserDefaults.standard
        if let value = defaults.object(forKey: self.rawValue) {
            return value as! T
        } else {
            return self.defaultValue()
        }
    }
	
	@discardableResult
    func setValue(_ value: T)->T {
        let defaults = UserDefaults.standard
        let oldValue = self.currentValue()
        defaults.set(value, forKey: self.rawValue)
        return oldValue
    }
}
