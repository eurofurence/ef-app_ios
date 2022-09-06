import CoreData
import EurofurenceWebAPI

// MARK: - Persistent Container

extension NSManagedObjectContext {
    
    /// The `NSPersistentContainer` that produced this managed object context.
    var persistentContainer: NSPersistentContainer? {
        get {
            userInfo.object(forKey: "EFKPersistentContainerKey") as? NSPersistentContainer
        }
        set {
            userInfo.setObject(newValue as Any, forKey: "EFKPersistentContainerKey" as NSCopying)
        }
    }
    
}

// MARK: - API

extension NSManagedObjectContext {
    
    /// The instance of the `EurofurenceAPI` in use by the model.
    var eurofurenceAPI: EurofurenceAPI? {
        get {
            userInfo.object(forKey: "EFKEurofurenceAPI") as? EurofurenceAPI
        }
        set {
            userInfo.setObject(newValue as Any, forKey: "EFKEurofurenceAPI" as NSCopying)
        }
    }
    
}
