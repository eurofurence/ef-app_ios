import Foundation

public struct HardcodedCompanionAppURLRequestFactory: CompanionAppURLRequestFactory {
    
    public init() {
        
    }
    
    public func makeAdditionalServicesRequest(authenticationToken: String?) -> URLRequest {
        let tokenValue = authenticationToken ?? ""
        
        guard let url = URL(string: "https://app.eurofurence.org/EF25/companion/#/login?embedded=true&returnPath=/collect&token=\(tokenValue)") else {
            fatalError("Unable to marshall companion app URL string into URL")
        }
        
        return URLRequest(url: url)
    }
    
}
