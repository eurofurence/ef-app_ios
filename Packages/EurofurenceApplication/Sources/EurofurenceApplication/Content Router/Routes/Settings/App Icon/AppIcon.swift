public struct AppIcon: CustomStringConvertible, Hashable {
    
    public var displayName: String
    public var imageFileName: String
    public var alternateIconName: String?
    
    public init(displayName: String, imageFileName: String, alternateIconName: String?) {
        self.displayName = displayName
        self.imageFileName = imageFileName
        self.alternateIconName = alternateIconName
    }
    
    public var description: String {
        "\(displayName) (\(imageFileName) = \(alternateIconName ?? "nil"))"
    }
    
}
