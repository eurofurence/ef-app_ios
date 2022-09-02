import CoreData

@objc(DealerThumbnail)
public class DealerThumbnail: Image {
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<DealerThumbnail> {
        return NSFetchRequest<DealerThumbnail>(entityName: "DealerThumbnail")
    }

    @NSManaged public var dealer: Dealer

}
