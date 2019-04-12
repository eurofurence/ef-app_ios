import EurofurenceModel
import Foundation

class StubCollectThemAllRequestFactory: CollectThemAllRequestFactory {

    let anonymousGameURLRequest = URLRequest(url: .random)
    func makeAnonymousGameURLRequest() -> URLRequest {
        return anonymousGameURLRequest
    }

    func makeAuthenticatedGameURLRequest(credential: Credential) -> URLRequest {
        let url = URL(string: "https://stub.\(credential.authenticationToken)")!
        return URLRequest(url: url)
    }

}
