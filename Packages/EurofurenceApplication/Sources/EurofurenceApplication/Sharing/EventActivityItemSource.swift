import ComponentBase
import EurofurenceModel
import LinkPresentation
import UIKit

public class EventActivityItemSource: URLBasedActivityItem {
    
    public var event: Event
    
    public init(event: Event) {
        self.event = event
        super.init(url: event.contentURL)
    }
    
    override public func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? EventActivityItemSource else { return false }
        return event.identifier == other.event.identifier
    }
    
    @available(iOS 13.0, *)
    override public func supplementLinkMetadata(_ metadata: LPLinkMetadata) {
        metadata.title = event.title
        
        if let bannerData = event.bannerGraphicPNGData, let bannerImage = UIImage(data: bannerData) {
            metadata.imageProvider = NSItemProvider(object: bannerImage)
        }
    }
    
}
