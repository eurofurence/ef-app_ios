import CoreData

@objc(ArtistImage)
public class ArtistImage: Image {
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<ArtistImage> {
        return NSFetchRequest<ArtistImage>(entityName: "ArtistImage")
    }

    @NSManaged public var artist: Dealer

}
