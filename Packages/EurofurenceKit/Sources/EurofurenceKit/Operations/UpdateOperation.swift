import CoreData
import EurofurenceWebAPI

protocol UpdateOperation {
    
    func execute(context: UpdateOperationContext) async throws
    
}

struct UpdateOperationContext {
    
    var managedObjectContext: NSManagedObjectContext
    var keychain: Keychain
    var api: EurofurenceAPI
    var properties: EurofurenceModelProperties
    var conventionIdentifier: ConventionIdentifier
    
}
