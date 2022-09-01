import Foundation

public class EurofurenceAPIDecoder: JSONDecoder {
    
    public override init() {
        super.init()
        dateDecodingStrategy = .formatted(EurofurenceISO8601DateFormatter.instance)
    }
    
    public func decodeSynchronizationPayload(from data: Data) throws -> SynchronizationPayload {
        try decode(SynchronizationPayload.self, from: data)
    }
    
}
