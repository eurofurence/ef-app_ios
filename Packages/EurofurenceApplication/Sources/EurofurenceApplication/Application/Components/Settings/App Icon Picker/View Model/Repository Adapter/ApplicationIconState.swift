import Combine

public protocol ApplicationIconState: AnyObject {
    
    associatedtype AlternateIconNamePublisher: Publisher where
        AlternateIconNamePublisher.Output == String?,
        AlternateIconNamePublisher.Failure == Never
    
    var alternateIconNamePublisher: AlternateIconNamePublisher { get }
    
    func updateApplicationIcon(alternateIconName: String?)
    
}
