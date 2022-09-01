import Foundation
import EurofurenceWebAPI

enum SampleResponse {
    
    case ef26
    case corruptEF26
    
    private var fileName: String {
        switch self {
        case .ef26:
            return "EF26_Full_Sync_Response"
        case .corruptEF26:
            return "EF26_Corrupt_Sync_Response"
        }
    }
    
    func loadContents() throws -> Data {
        guard let url = Bundle.module.url(forResource: fileName, withExtension: "json") else {
            fatalError("Missing resource \(fileName).json")
        }
        
        return try Data(contentsOf: url)
    }
    
    func loadResponse() throws -> SynchronizationPayload {
        let fileContents = try loadContents()
        let decoder = EurofurenceAPIDecoder()
        
        return try decoder.decodeSynchronizationPayload(from: fileContents)
    }
    
}
