import Foundation

public protocol UserPreferences {

    var refreshStoreOnLaunch: Bool { get }
    var upcomingEventReminderInterval: TimeInterval { get }

}
