import CoreData

extension NSManagedObjectModel {
    
    static var eurofurenceModel: NSManagedObjectModel = {
        guard let url = Bundle.module.url(forResource: "Model", withExtension: "momd") else {
            fatalError("NSManagedObjectModel definition missing from bundle")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Unable to decode NSManagedObjectModel from contents of model. URL=\(url)")
        }
        
        return managedObjectModel
    }()
    
}
