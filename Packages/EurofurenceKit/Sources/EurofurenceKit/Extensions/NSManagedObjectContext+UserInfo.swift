import CoreData
import EurofurenceWebAPI

extension NSManagedObjectContext {
    
    private struct Keys {
        static let persistentContainerKey = "EFKPersistentContainer"
        static let propertiesKey = "EFKModelProperties"
        static let keychainKey = "EFKKeychain"
        static let apiKey = "EFKEurofurenceAPI"
        static let eventCalendarKey = "EFKEventCalendar"
    }
    
    /// The `NSPersistentContainer` that produced this managed object context.
    var persistentContainer: NSPersistentContainer? {
        get {
            userInfo.object(forKey: Keys.persistentContainerKey) as? NSPersistentContainer
        }
        set {
            userInfo.setObject(newValue as Any, forKey: Keys.persistentContainerKey as NSCopying)
        }
    }
    
    /// The collection of properties in use by the model.
    var properties: EurofurenceModelProperties? {
        get {
            userInfo.object(forKey: Keys.propertiesKey) as? EurofurenceModelProperties
        }
        set {
            userInfo.setObject(newValue as Any, forKey: Keys.propertiesKey as NSCopying)
        }
    }
    
    /// The `Keychain` in use by the model, for fetching the credentials of the current user.
    var keychain: Keychain? {
        get {
            userInfo.object(forKey: Keys.keychainKey) as? Keychain
        }
        set {
            userInfo.setObject(newValue as Any, forKey: Keys.keychainKey as NSCopying)
        }
    }
    
    /// The instance of the `EurofurenceAPI` in use by the model.
    var eurofurenceAPI: EurofurenceAPI? {
        get {
            userInfo.object(forKey: Keys.apiKey) as? EurofurenceAPI
        }
        set {
            userInfo.setObject(newValue as Any, forKey: Keys.apiKey as NSCopying)
        }
    }
    
    /// The instance of the `EventCalendar` in use by the model.
    var eventsCalendar: EventCalendar? {
        get {
            userInfo.object(forKey: Keys.eventCalendarKey) as? EventCalendar
        }
        set {
            userInfo.setObject(newValue as Any, forKey: Keys.eventCalendarKey as NSCopying)
        }
    }
    
}

// MARK: - NSManagedObject Convenience

extension NSManagedObject {
    
    /// The instance of the `EurofurenceAPI` in use by the model.
    var eurofurenceAPI: EurofurenceAPI {
        unsafeAccess(managedObjectContextKeyPath: \.eurofurenceAPI)
    }
    
    /// The instance of the `EventCalendar` in use by the model.
    var eventsCalendar: EventCalendar {
        unsafeAccess(managedObjectContextKeyPath: \.eventsCalendar)
    }
    
    private func unsafeAccess<T>(managedObjectContextKeyPath: KeyPath<NSManagedObjectContext, T?>) -> T {
        guard let managedObjectContext = managedObjectContext else {
            fatalError("\(self) not associated with a NSManagedObjectContext")
        }
        
        guard let value = managedObjectContext[keyPath: managedObjectContextKeyPath] else {
            fatalError("\(managedObjectContext) has no value for key path \(managedObjectContextKeyPath)")
        }
        
        return value
    }
    
}
