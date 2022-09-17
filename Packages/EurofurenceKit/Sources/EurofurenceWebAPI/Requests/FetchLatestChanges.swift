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
        
    }
    
}
