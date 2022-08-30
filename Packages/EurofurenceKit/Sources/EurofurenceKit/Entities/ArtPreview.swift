import CoreData

@objc(ArtPreview)
public class ArtPreview: Image {
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<ArtPreview> {
        return NSFetchRequest<ArtPreview>(entityName: "ArtPreview")
    }

    @NSManaged public var caption: String
    @NSManaged public var artist: Dealer

}
