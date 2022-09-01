import CoreData
import EurofurenceWebAPI

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

}

// MARK: - Dealer + ConsumesRemoteResponse

extension Dealer: ConsumesRemoteResponse {
    
    typealias RemoteObject = RemoteDealer
    
    func update(context: RemoteResponseConsumingContext<RemoteDealer>) throws {
        updateAttributes(context)
        updateLinks(context)
        updateArtistImage(context)
        updateArtPreview(context)
        updateArtistThumbnail(context)
        updateCategories(context)
    }
    
    private func updateAttributes(_ context: RemoteResponseConsumingContext<RemoteDealer>) {
        lastEdited = context.remoteObject.lastChangeDateTimeUtc
        identifier = context.remoteObject.id
        aboutTheArt = context.remoteObject.aboutTheArtText
        aboutTheArtist = context.remoteObject.aboutTheArtistText
        attendeeNickname = context.remoteObject.attendeeNickname
        dealerShortDescription = context.remoteObject.shortDescription
        displayName = context.remoteObject.displayName
        thursdayAttendance = context.remoteObject.attendsOnThursday
        fridayAttendance = context.remoteObject.attendsOnFriday
        saturdayAttendance = context.remoteObject.attendsOnSaturday
        isAfterDark = context.remoteObject.isAfterDark
        merchanise = context.remoteObject.merchandise
        registrationNumber = Int16(context.remoteObject.registrationNumber)
        telegramHandle = context.remoteObject.telegramHandle
        twitterHandle = context.remoteObject.twitterHandle
    }
    
    private func updateLinks(_ context: RemoteResponseConsumingContext<RemoteDealer>) {
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
    
    private func removeAllLinks(_ context: RemoteResponseConsumingContext<RemoteDealer>) {
        for link in links {
            removeFromLinks(link)
            context.managedObjectContext.delete(link)
        }
    }
    
    private func updateArtistImage(_ context: RemoteResponseConsumingContext<RemoteDealer>) {
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
    
    private func updateArtPreview(_ context: RemoteResponseConsumingContext<RemoteDealer>) {
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
    
    private func updateArtistThumbnail(_ context: RemoteResponseConsumingContext<RemoteDealer>) {
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
    
    private func updateCategories(_ context: RemoteResponseConsumingContext<RemoteDealer>) {
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
