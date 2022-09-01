public struct Link: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case fragmentType = "FragmentType"
        case name = "Name"
        case target = "Target"
    }
    
    public var fragmentType: String
    public var name: String
    public var target: String
    
}
