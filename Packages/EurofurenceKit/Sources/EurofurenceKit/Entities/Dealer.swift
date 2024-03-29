import CoreData
import EurofurenceWebAPI

@objc(Dealer)
public class Dealer: Entity {

    @nonobjc class func fetchRequest() -> NSFetchRequest<Dealer> {
        return NSFetchRequest<Dealer>(entityName: "Dealer")
    }
    
    @NSManaged var attendeeNickname: String
    @NSManaged var displayName: String

    @NSManaged public var name: String
    @NSManaged public var aboutTheArt: String
    @NSManaged public var aboutTheArtist: String
    @NSManaged public var dealerShortDescription: String
    @NSManaged public var thursdayAttendance: Bool
    @NSManaged public var fridayAttendance: Bool
    @NSManaged public var saturdayAttendance: Bool
    @NSManaged public var isAfterDark: Bool
    @NSManaged public var merchanise: String
    @NSManaged public var registrationNumber: Int16
    @NSManaged public var telegramHandle: String
    @NSManaged public var twitterHandle: String
    @NSManaged public var artistImage: ArtistImage?
    @NSManaged public var artPreview: ArtPreview?
    @NSManaged public var categories: Set<DealerCategory>
    @NSManaged public var links: Set<DealerLink>
    @NSManaged public var thumbnail: DealerThumbnail?
    @NSManaged public var indexingTitle: String

}

// MARK: Dealer + Comparable

extension Dealer: Comparable {
    
    public static func < (lhs: Dealer, rhs: Dealer) -> Bool {
        lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending
    }

}

// MARK: - Dealer + ConsumesRemoteResponse

extension Dealer: ConsumesRemoteResponse {
    
    typealias RemoteObject = EurofurenceWebAPI.Dealer
    
    func update(context: RemoteResponseConsumingContext<RemoteObject>) throws {
        updateAttributes(context)
        updateLinks(context)
        updateArtistImage(context)
        updateArtPreview(context)
        updateArtistThumbnail(context)
        updateCategories(context)
    }
    
    private func updateAttributes(_ context: RemoteResponseConsumingContext<RemoteObject>) {
        let remoteObject = context.remoteObject
        lastEdited = remoteObject.lastChangeDateTimeUtc
        identifier = remoteObject.id
        aboutTheArt = remoteObject.aboutTheArtText
        aboutTheArtist = remoteObject.aboutTheArtistText
        attendeeNickname = remoteObject.attendeeNickname
        dealerShortDescription = remoteObject.shortDescription
        displayName = remoteObject.displayName
        thursdayAttendance = remoteObject.attendsOnThursday
        fridayAttendance = remoteObject.attendsOnFriday
        saturdayAttendance = remoteObject.attendsOnSaturday
        isAfterDark = remoteObject.isAfterDark
        merchanise = remoteObject.merchandise
        registrationNumber = Int16(remoteObject.registrationNumber)
        telegramHandle = remoteObject.telegramHandle
        twitterHandle = remoteObject.twitterHandle
        name = remoteObject.displayName.isEmpty ? remoteObject.attendeeNickname : remoteObject.displayName
        
        if let firstCharacter = name.first {
            indexingTitle = String(firstCharacter)
        } else {
            indexingTitle = ""
        }
    }
    
    private func updateLinks(_ context: RemoteResponseConsumingContext<RemoteObject>) {
        removeAllLinks(context)
        
        if let links = context.remoteObject.links {
            for link in links {
                let dealerLink = DealerLink(context: context.managedObjectContext)
                dealerLink.fragmentType = link.fragmentType
                dealerLink.target = link.target
                dealerLink.name = link.name
                addToLinks(dealerLink)
            }
        }
    }
    
    private func removeAllLinks(_ context: RemoteResponseConsumingContext<RemoteObject>) {
        for link in links {
            removeFromLinks(link)
            context.managedObjectContext.delete(link)
        }
    }
    
    private func updateArtistImage(_ context: RemoteResponseConsumingContext<RemoteObject>) {
        // TODO: Update removing image should clear the current reference.
        let artistImageID = context.remoteObject.artistImageId
        if let artistImageID = artistImageID, let image = context.image(identifiedBy: artistImageID) {
            if let artistImage = artistImage {
                artistImage.update(from: image)
            } else {
                let artistImage = ArtistImage(context: context.managedObjectContext)
                artistImage.update(from: image)
                self.artistImage = artistImage
            }
        }
    }
    
    private func updateArtPreview(_ context: RemoteResponseConsumingContext<RemoteObject>) {
        // TODO: Update removing image should clear the current reference.
        let artPreviewID = context.remoteObject.artPreviewImageId
        if let artPreviewID = artPreviewID, let image = context.image(identifiedBy: artPreviewID) {
            if let artPreview = artPreview {
                artPreview.caption = context.remoteObject.artPreviewCaption
                artPreview.update(from: image)
            } else {
                let artPreview = ArtPreview(context: context.managedObjectContext)
                artPreview.caption = context.remoteObject.artPreviewCaption
                artPreview.update(from: image)
                self.artPreview = artPreview
            }
        }
    }
    
    private func updateArtistThumbnail(_ context: RemoteResponseConsumingContext<RemoteObject>) {
        // TODO: Update removing image should clear the current reference.
        let thumbnailID = context.remoteObject.artistThumbnailImageId
        if let thumbnailID = thumbnailID, let image = context.image(identifiedBy: thumbnailID) {
            if let thumbnail = thumbnail {
                thumbnail.update(from: image)
            } else {
                let thumbnail = DealerThumbnail(context: context.managedObjectContext)
                thumbnail.update(from: image)
                self.thumbnail = thumbnail
            }
        }
    }
    
    private func updateCategories(_ context: RemoteResponseConsumingContext<RemoteObject>) {
        for category in context.remoteObject.categories {
            let dealerCategory = DealerCategory.named(name: category, in: context.managedObjectContext)
            addToCategories(dealerCategory)
        }
    }
    
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
