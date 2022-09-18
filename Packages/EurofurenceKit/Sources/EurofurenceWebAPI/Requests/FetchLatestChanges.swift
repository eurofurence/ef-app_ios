extension APIRequests {
    
    /// A request to fetch the latest payload of changes from the API.
    ///
    /// Change sets are determined through the use of generation tokens, which represent previous points in time a
    /// change fetch request has occurred. When `nil`, the entire contents of the remote store will be provided in a
    /// payload. Future fetches should then send the previous payload's generation token in order to fetch only the
    /// changes that have occurred between the two requests.
    public struct FetchLatestChanges: APIRequest {
        
        public typealias Output = SynchronizationPayload
        
        /// The last known generation token for fetching the next set of changes.
        public let previousChangeToken: SynchronizationPayload.GenerationToken?
        
        public init(since previousChangeToken: SynchronizationPayload.GenerationToken?) {
            self.previousChangeToken = previousChangeToken
        }
        
        public func execute(with context: APIRequestExecutionContext) async throws -> SynchronizationPayload {
            let sinceToken: String = {
                if let lastUpdateTime = previousChangeToken?.lastSyncTime {
                    let formattedTime = EurofurenceISO8601DateFormatter.instance.string(from: lastUpdateTime)
                    return "?since=\(formattedTime)"
                } else {
                    return ""
                }
            }()
            
            let url = context.makeURL(subpath: "Sync\(sinceToken)")
            let request = NetworkRequest(url: url, method: .get)
            
            let data = try await context.network.perform(request: request)
            let response = try context.decoder.decode(SynchronizationPayload.self, from: data)
            
            return response
        }
        
    }
    
}
