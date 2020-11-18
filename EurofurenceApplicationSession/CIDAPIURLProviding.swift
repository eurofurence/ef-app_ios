import EurofurenceModel

public struct CIDAPIURLProviding: APIURLProviding {
    
    public init(conventionIdentifier: ConventionIdentifier) {
        url = "https://app.eurofurence.org/\(conventionIdentifier.identifier)/api"
    }
    
    public var url: String
    
}
