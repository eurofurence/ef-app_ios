public struct AppIcon: CustomStringConvertible, Hashable {
    
    public var displayName: String
    public var imageFileName: String
    
    public init(displayName: String, imageFileName: String) {
        self.displayName = displayName
        self.imageFileName = imageFileName
    }
    
    public var description: String {
        "\(displayName) (\(imageFileName))"
    }
    
}
