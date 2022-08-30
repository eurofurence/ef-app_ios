import CoreData

@objc(Dealer)
public class Dealer: Entity {

    @nonobjc class func fetchRequest() -> NSFetchRequest<Dealer> {
        return NSFetchRequest<Dealer>(entityName: "Dealer")
    }

    @NSManaged public var aboutTheArt: String
    @NSManaged public var aboutTheArtist: String
    @NSManaged public var attendeeNickname: String
    @NSManaged public var dealerShortDescription: String
    @NSManaged public var displayName: String
    @NSManaged public var fridayAttendance: Bool
    @NSManaged public var isAfterDark: Bool
    @NSManaged public var merchanise: String
    @NSManaged public var registrationNumber: Int16
    @NSManaged public var saturdayAttendance: Bool
    @NSManaged public var telegramHandle: String
    @NSManaged public var thursdayAttendance: Bool
    @NSManaged public var twitterHandle: String
    @NSManaged public var artistImage: ArtistImage?
    @NSManaged public var artPreview: ArtPreview?
    @NSManaged public var categories: Set<DealerCategory>
    @NSManaged public var links: Set<DealerLink>
    @NSManaged public var thumbnail: DealerThumbnail?

}

// MARK: Generated accessors for categories
extension Dealer {

    @objc(addCategoriesObject:)
    @NSManaged func addToCategories(_ value: DealerCategory)

    @objc(removeCategoriesObject:)
    @NSManaged func removeFromCategories(_ value: DealerCategory)

    @objc(addCategories:)
    @NSManaged func addToCategories(_ values: Set<DealerCategory>)

    @objc(removeCategories:)
    @NSManaged func removeFromCategories(_ values: Set<DealerCategory>)

}

// MARK: Generated accessors for links
extension Dealer {

    @objc(addLinksObject:)
    @NSManaged func addToLinks(_ value: DealerLink)

    @objc(removeLinksObject:)
    @NSManaged func removeFromLinks(_ value: DealerLink)

    @objc(addLinks:)
    @NSManaged func addToLinks(_ values: Set<DealerLink>)

    @objc(removeLinks:)
    @NSManaged func removeFromLinks(_ values: Set<DealerLink>)

}
