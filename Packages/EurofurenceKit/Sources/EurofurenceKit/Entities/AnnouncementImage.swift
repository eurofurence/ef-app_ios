import CoreData

@objc(AnnouncementImage)
public class AnnouncementImage: Image {
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<AnnouncementImage> {
        return NSFetchRequest<AnnouncementImage>(entityName: "AnnouncementImage")
    }

    @NSManaged public var announcement: Announcement

}
