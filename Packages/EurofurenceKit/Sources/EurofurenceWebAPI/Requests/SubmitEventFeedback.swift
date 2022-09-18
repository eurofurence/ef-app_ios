extension APIRequests {
    
    public struct SubmitEventFeedback: APIRequest {
        
        private let identifier: String
        private let rating: Int
        private let additionalComments: String
        
        public init(
            identifier: String,
            rating: Int,
            additionalComments: String
        ) {
            self.identifier = identifier
            self.rating = rating
            self.additionalComments = additionalComments
        }
        
        public typealias Output = Void
        
        public func execute(with context: APIRequestExecutionContext) async throws {
            
        }
        
    }
    
}
