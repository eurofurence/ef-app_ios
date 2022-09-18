extension APIRequests {
    
    /// A request to fetch the contents of the configuration made available to the model.
    public struct FetchConfiguration: APIRequest {
        
        public typealias Output = RemoteConfiguration
        
        public init() {
            
        }
        
        public func execute(with context: APIRequestExecutionContext) async throws -> Output {
            FirebaseRemoteConfiguration.shared
        }
        
    }
    
}
