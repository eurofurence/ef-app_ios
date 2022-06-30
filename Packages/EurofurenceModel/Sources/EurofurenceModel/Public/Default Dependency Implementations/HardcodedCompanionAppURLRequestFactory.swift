import Foundation

public struct HardcodedCompanionAppURLRequestFactory: CompanionAppURLRequestFactory {
    
    private let conventionIdentifier: ConventionIdentifier
    
    public init(conventionIdentifier: ConventionIdentifier) {
        self.conventionIdentifier = conventionIdentifier
    }
    
    public func makeAdditionalServicesRequest(authenticationToken: String?) -> URLRequest {
        let tokenValue = authenticationToken ?? ""
        let cid = conventionIdentifier.identifier
        
        let baseURL = "https://app.eurofurence.org/\(cid)/companion/#/login?embedded=true&returnPath=/&token="
        
        guard let url = URL(string: "\(baseURL)\(tokenValue)") else {
            fatalError("Unable to marshall companion app URL string into URL")
        }
        
        return URLRequest(url: url)
    }
    
}
