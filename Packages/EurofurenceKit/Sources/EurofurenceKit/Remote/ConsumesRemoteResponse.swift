import CoreData

struct RemoteResponseConsumingContext<Object> {
    
    var managedObjectContext: NSManagedObjectContext
    var remoteObject: Object
    var response: RemoteSyncResponse
    
}

protocol ConsumesRemoteResponse {
    
    associatedtype RemoteObject
    
    func update(context: RemoteResponseConsumingContext<RemoteObject>) throws
    
}
