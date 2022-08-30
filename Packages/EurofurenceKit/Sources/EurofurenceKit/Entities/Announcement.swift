import CoreData

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
