import Foundation

protocol EventActionBannerComponent {
    
    func setActionTitle(_ title: String)
    func setSelectionHandler(_ handler: @escaping () -> Void)
    
}
