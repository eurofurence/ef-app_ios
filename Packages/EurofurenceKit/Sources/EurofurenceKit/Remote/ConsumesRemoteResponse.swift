import CoreData

struct RemoteResponseConsumingContext<Object> {
    
    var managedObjectContext: NSManagedObjectContext
    var remoteObject: Object
    var response: RemoteSyncResponse
    
    func image(identifiedBy identifier: RemoteImage.ID) -> RemoteImage? {
        response.images.changed.first(where: { $0.id == identifier })
    }
    
}

protocol ConsumesRemoteResponse {
    
    associatedtype RemoteObject
    
    func update(context: RemoteResponseConsumingContext<RemoteObject>) throws
    
}
