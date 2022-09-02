import CoreData
import EurofurenceWebAPI

@objc(Image)
public class Image: Entity {
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image")
    }

    @NSManaged public var contentHashSHA1: String
    @NSManaged public var estimatedSizeInBytes: Int64
    @NSManaged public var internalReference: String
    @NSManaged public var mimeType: String
    @NSManaged var width: Int32
    @NSManaged var height: Int32

}

// MARK: - Sizing

extension Image {
    
    public var size: Size {
        Size(width: Int(width), height: Int(height))
    }
    
    public struct Size: Equatable {
        
        public var width: Int
        public var height: Int
        
        public init(width: Int, height: Int) {
            self.width = width
            self.height = height
        }
        
    }
    
}

// MARK: - Fetching

extension Image {
    
    class func identifiedBy(
        identifier: String,
        in managedObjectContext: NSManagedObjectContext
    ) -> Self {
        let entityDescription: NSEntityDescription = Self.entity()
        guard let entityName = entityDescription.name else {
            fatalError("Entity \(String(describing: Self.self)) does not possess a name in its NSEntityDescription!")
        }
        
        let fetchRequest: NSFetchRequest<Self> = NSFetchRequest(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
        let results = try? managedObjectContext.fetch(fetchRequest)
        
        if let existingImage = results?.first {
            return existingImage
        } else {
            let newImage = Self.init(context: managedObjectContext)
            newImage.identifier = identifier
            return newImage
        }
    }
    
}

// MARK: - Consuming Remote Response

extension Image {
    
    func update(from remoteResponse: EurofurenceWebAPI.Image) {
        identifier = remoteResponse.id
        lastEdited = remoteResponse.lastChangeDateTimeUtc
        contentHashSHA1 = remoteResponse.contentHashSha1
        estimatedSizeInBytes = Int64(remoteResponse.sizeInBytes)
        internalReference = remoteResponse.internalReference
        mimeType = remoteResponse.mimeType
        width = Int32(remoteResponse.width)
        height = Int32(remoteResponse.height)
    }
    
}
