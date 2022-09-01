import CoreData
import EurofurenceWebAPI

@objc(Announcement)
public class Announcement: Entity {
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<Announcement> {
        return NSFetchRequest<Announcement>(entityName: "Announcement")
    }

    @NSManaged public var area: String
    @NSManaged public var author: String
    @NSManaged public var contents: String
    @NSManaged public var title: String
    @NSManaged public var validFrom: Date
    @NSManaged public var validUntil: Date
    @NSManaged public var image: AnnouncementImage?

}

// MARK: - Announcement + ConsumesRemoteResponse

extension Announcement: ConsumesRemoteResponse {
    
    typealias RemoteObject = EurofurenceWebAPI.Announcement
    
    func update(context: RemoteResponseConsumingContext<RemoteObject>) throws {
        identifier = context.remoteObject.id
        lastEdited = context.remoteObject.lastChangeDateTimeUtc
        validFrom = context.remoteObject.validFromDateTimeUtc
        validUntil = context.remoteObject.validUntilDateTimeUtc
        area = context.remoteObject.area
        author = context.remoteObject.author
        title = context.remoteObject.title
        contents = context.remoteObject.content
        
        let imageID = context.remoteObject.imageIdentifier
        if let imageID = imageID, let image = context.image(identifiedBy: imageID) {
            if let existingImage = self.image {
                existingImage.update(from: image)
            } else {            
                let announcementImage = AnnouncementImage(context: context.managedObjectContext)
                announcementImage.update(from: image)
                self.image = announcementImage
            }
        }
    }
    
}
