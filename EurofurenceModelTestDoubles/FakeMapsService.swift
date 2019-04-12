import EurofurenceModel
import Foundation

public class FakeMapsService: MapsService {
    
    public init() {
        
    }
    
    public let maps = [StubMap].random
    public func add(_ observer: MapsObserver) {
        observer.mapsServiceDidChangeMaps(maps)
    }
    
    public func fetchMap(for identifier: MapIdentifier) -> Map? {
        return maps.first(where: { $0.identifier == identifier })
    }
    
}
