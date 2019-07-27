import EurofurenceModel

struct ShareEventActionViewModel: EventActionViewModel {
    
    let event: Event
    let shareService: ShareService
    
    func describe(to visitor: EventActionViewModelVisitor) {
        visitor.visitActionTitle(.share)
    }
    
    func perform(sender: Any?) {
        guard let sender = sender else { return }
        
        let url = event.makeContentURL()
        shareService.share(url, sender: sender)
    }
    
}
