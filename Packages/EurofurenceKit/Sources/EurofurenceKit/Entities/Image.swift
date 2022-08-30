import CoreData

@objc(Image)
public class Image: Entity {
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image")
    }

    @NSManaged public var contentHashSHA1: String
    @NSManaged public var estimatedSizeInBytes: Int64
    @NSManaged public var height: Int32
    @NSManaged public var internalReference: String
    @NSManaged public var mimeType: String
    @NSManaged public var width: Int32

}
