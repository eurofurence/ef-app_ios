struct RemoteLink: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case fragmentType = "FragmentType"
        case name = "Name"
        case target = "Target"
    }
    
    var fragmentType: String
    var name: String
    var target: String
    
}
