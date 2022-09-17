import Foundation

public protocol API {

    func fetchLatestData(lastSyncTime: Date?, completionHandler: @escaping (ModelCharacteristics?) -> Void)

    func fetchImage(identifier: String, contentHashSha1: String, completionHandler: @escaping (Data?) -> Void)

    func performLogin(request: APIRequests.LoginRequest, completionHandler: @escaping (LoginResponse?) -> Void)

    func loadPrivateMessages(
        authorizationToken: String, 
        completionHandler: @escaping ([MessageCharacteristics]?) -> Void
    )

    func markMessageWithIdentifierAsRead(_ identifier: String, authorizationToken: String)
    
    func submitEventFeedback(_ request: EventFeedbackRequest, completionHandler: @escaping (Bool) -> Void)

}
