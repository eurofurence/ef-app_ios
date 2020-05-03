import Foundation.NSAttributedString

public struct AnnouncementViewModel {

    public var heading: String
    public var contents: NSAttributedString
    public var imagePNGData: Data?
    
    public init(heading: String, contents: NSAttributedString, imagePNGData: Data?) {
        self.heading = heading
        self.contents = contents
        self.imagePNGData = imagePNGData
    }

}
