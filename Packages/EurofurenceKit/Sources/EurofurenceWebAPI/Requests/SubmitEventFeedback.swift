extension APIRequests {
    
    public struct SubmitEventFeedback: APIRequest {
        
        private let identifier: String
        private let percentageRating: Float
        private let additionalComments: String
        
        public init(
            identifier: String,
            percentageRating: Float,
            additionalComments: String
        ) {
            self.identifier = identifier
            self.percentageRating = percentageRating
            self.additionalComments = additionalComments
        }
        
        public typealias Output = Void
        
        public func execute(with context: APIRequestExecutionContext) async throws {
            
        }
        
    }
    
}
