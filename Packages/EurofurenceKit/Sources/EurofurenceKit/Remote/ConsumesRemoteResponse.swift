import CoreData
import EurofurenceWebAPI

struct RemoteResponseConsumingContext<Object> {
    
    var managedObjectContext: NSManagedObjectContext
    var remoteObject: Object
    var response: SynchronizationPayload
    
    func image(identifiedBy identifier: EurofurenceWebAPI.Image.ID) -> EurofurenceWebAPI.Image? {
        response.images.changed.first(where: { $0.id == identifier })
    }
    
}

protocol ConsumesRemoteResponse {
    
    associatedtype RemoteObject
    
    func update(context: RemoteResponseConsumingContext<RemoteObject>) throws
    
}
