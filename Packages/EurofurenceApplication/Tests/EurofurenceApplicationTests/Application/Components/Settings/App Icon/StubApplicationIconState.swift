import Combine
import EurofurenceApplication

class StubApplicationIconState: ApplicationIconState {
    
    typealias AlternateIconNamePublisher = CurrentValueSubject<String?, Never>
    
    func updateApplicationIcon(alternateIconName: String?) {
        alternateIconNamePublisher.send(alternateIconName)
    }
    
    let alternateIconNamePublisher = CurrentValueSubject<String?, Never>(nil)
    
}
