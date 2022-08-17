import Combine
import UIKit

class UIKitApplicationIconState: ApplicationIconState {
    
    let alternateIconNamePublisher = CurrentValueSubject<String?, Never>(nil)
    
    init() {
        alternateIconNamePublisher.value = UIApplication.shared.alternateIconName
    }
    
    func updateApplicationIcon(alternateIconName: String?) {
        UIApplication.shared.setAlternateIconName(alternateIconName) { [alternateIconNamePublisher] error in
            DispatchQueue.main.async {            
                if error != nil {
                    alternateIconNamePublisher.send(alternateIconName)
                }
            }
        }
    }
    
}
