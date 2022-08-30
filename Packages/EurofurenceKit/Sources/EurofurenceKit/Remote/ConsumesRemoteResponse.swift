protocol ConsumesRemoteResponse {
    
    associatedtype RemoteResponse
    
    func update(from remoteResponse: RemoteResponse)
    
}
