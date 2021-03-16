import EurofurenceComponentBase
import EurofurenceModel

public class ShareEventActionViewModel: EventActionViewModel {
    
    private let event: Event
    private let shareService: ShareService
    
    init(event: Event, shareService: ShareService) {
        self.event = event
        self.shareService = shareService
    }
    
    public func describe(to visitor: EventActionViewModelVisitor) {
        visitor.visitActionTitle(.share)
    }
    
    public func perform(sender: Any?) {
        guard let sender = sender else { return }
        shareService.share(EventActivityItemSource(event: event), sender: sender)
    }
    
}
