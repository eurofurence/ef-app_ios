import Foundation

public protocol EventActionBannerComponent {
    
    func setActionTitle(_ title: String)
    func setSelectionHandler(_ handler: @escaping (Any) -> Void)
    
}
