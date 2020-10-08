import Foundation

struct MapImpl: Map {
    
    private let imageRepository: ImageRepository
    private let dataStore: DataStore
    private let characteristics: MapCharacteristics
    private let dealers: ConcreteDealersService

    var identifier: MapIdentifier
    var location: String

    init(
        imageRepository: ImageRepository,
        dataStore: DataStore,
        characteristics: MapCharacteristics,
        dealers: ConcreteDealersService
    ) {
        self.imageRepository = imageRepository
        self.dataStore = dataStore
        self.characteristics = characteristics
        self.dealers = dealers
        
        self.identifier = MapIdentifier(characteristics.identifier)
        self.location = characteristics.mapDescription
    }
    
    func fetchImagePNGData(completionHandler: @escaping (Data) -> Void) {
        if let image = imageRepository.loadImage(identifier: characteristics.imageIdentifier) {
            completionHandler(image.pngImageData)
        }
    }
    
    private struct MapEntryDisplacementResult {
        var entry: MapCharacteristics.Entry
        var displacement: Double
    }
    
    func fetchContentAt(x: Int, y: Int, completionHandler: @escaping (MapContent) -> Void) {
        var content: MapContent = .none
        defer { completionHandler(content) }
        
        let tappedWithinEntry: (MapCharacteristics.Entry) -> MapEntryDisplacementResult? = { (entry) -> MapEntryDisplacementResult? in
            let tapRadius = entry.tapRadius
            let horizontalDelta = abs(entry.x - x)
            let verticalDelta = abs(entry.y - y)
            let delta = hypot(Double(horizontalDelta), Double(verticalDelta))
            
            guard delta < Double(tapRadius) else { return nil }
            
            return MapEntryDisplacementResult(entry: entry, displacement: delta)
        }
        
        guard let entry = characteristics.entries.compactMap(tappedWithinEntry).min(by: { $0.displacement < $1.displacement })?.entry else { return }
        
        let contentFromLink: (MapCharacteristics.Entry.Link) -> MapContent? = { (link) in
            if let room = self.dataStore.fetchRooms()?.first(where: { $0.identifier == link.target }) {
                return .room(Room(name: room.name))
            }
            
            if let dealer = self.dealers.fetchDealer(for: DealerIdentifier(link.target)) {
                return .dealer(dealer)
            }
            
            if link.type == .mapEntry, let linkedEntry = self.characteristics.entries.first(where: { $0.identifier == link.target }), let name = link.name {
                return .location(x: Float(linkedEntry.x), y: Float(linkedEntry.y), name: name)
            }
            
            return nil
        }
        
        let links = entry.links
        let contents: [MapContent] = links.compactMap(contentFromLink)
        content = contents.reduce(into: MapContent.none, +)
    }

}
