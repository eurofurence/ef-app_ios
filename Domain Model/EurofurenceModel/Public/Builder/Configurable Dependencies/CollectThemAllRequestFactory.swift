import Foundation

public protocol CollectThemAllRequestFactory {

    func makeAnonymousGameURLRequest() -> URLRequest
    func makeAuthenticatedGameURLRequest(credential: Credential) -> URLRequest

}
