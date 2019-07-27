import EurofurenceModel

public struct StubAPIURLProviding: APIURLProviding {

    public init(url: String = "https://api.example.com/v2/") {
        self.url = url
    }

    public let url: String

}
