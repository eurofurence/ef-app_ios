import Foundation

struct UserDefaultsPreferences: UserPreferences {

    private let defaults = UserDefaults.standard

    private struct Keys {
        static var refreshStoreOnLaunchKey = "EFAutoRefreshDataStoreWhenAppDidLaunch"
    }

    init() {
        defaults.register(defaults: [Keys.refreshStoreOnLaunchKey: false])
    }

    var refreshStoreOnLaunch: Bool {
        return defaults.bool(forKey: Keys.refreshStoreOnLaunchKey)
    }

    var upcomingEventReminderInterval: TimeInterval {
        return 900
    }

}
