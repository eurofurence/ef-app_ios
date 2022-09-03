import EurofurenceWebAPI
import Foundation

enum SampleResponse {
    
    case deleteAll
    case ef26
    case corruptEF26
    case noChanges
    case deletedAnnouncement
    case deletedEvent
    case deletedEventWithBanner
    case deletedEventWithPoster
    case deletedEventWithSharedPoster
    case deletedEventHostedByBirdy
    case deletedDealer
    case deletedDealersWithinFursuitCategory
    case deletedKnowledgeGroup
    case deletedRoom
    
    private var fileName: String {
        switch self {
        case .deleteAll:
            return "DeleteAll"
        case .ef26:
            return "EF26_Full_Sync_Response"
        case .corruptEF26:
            return "EF26_Corrupt_Sync_Response"
        case .noChanges:
            return "NoChanges"
        case .deletedAnnouncement:
            return "EF26_DeleteAnnouncement"
        case .deletedEvent:
            return "EF26_DeleteEvent"
        case .deletedEventWithBanner:
            return "EF26_DeleteEvent_WithBanner"
        case .deletedEventWithPoster:
            return "EF26_DeleteEvent_WithPoster"
        case .deletedEventWithSharedPoster:
            return "EF26_DeleteEvent_WithSharedPoster"
        case .deletedEventHostedByBirdy:
            return "EF26_DeleteEventHostedByBirdy"
        case .deletedDealer:
            return "EF26_DeleteDealer"
        case .deletedDealersWithinFursuitCategory:
            return "EF26_DeleteDealers_FursuitCategoryOnly"
        case .deletedKnowledgeGroup:
            return "EF26_DeleteKnowledgeGroup"
        case .deletedRoom:
            return "EF26_DeleteRoom"
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
