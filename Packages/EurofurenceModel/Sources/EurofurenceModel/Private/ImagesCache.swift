import Foundation

struct ImagesCache {

    // MARK: Properties

    private let imageRepository: ImageRepository
    private let subscription: Any

    // MARK: Initialization

    init(eventBus: EventBus, imageRepository: ImageRepository) {
        self.imageRepository = imageRepository
        
        let saveDownloadedImageToRepository = SaveDownloadedImageToRepository(imageRepository: imageRepository)
        subscription = eventBus.subscribe(consumer: saveDownloadedImageToRepository)
    }

    // MARK: Functions

    func cachedImageData(for identifier: String) -> Data? {
        return imageRepository.loadImage(identifier: identifier)?.pngImageData
    }

    func deleteImage(identifier: String) {
        imageRepository.deleteEntity(identifier: identifier)
    }
    
    private struct SaveDownloadedImageToRepository: EventConsumer {
        
        let imageRepository: ImageRepository
        
        func consume(event: ImageDownloadedEvent) {
            let entity = ImageEntity(identifier: event.identifier, pngImageData: event.pngImageData)
            imageRepository.save(entity)
        }
        
    }

}
