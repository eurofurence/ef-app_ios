import Foundation

protocol DealerComponent {

    func setDealerTitle(_ title: String)
    func setDealerSubtitle(_ subtitle: String?)
    func setDealerIconPNGData(_ pngData: Data)
    func showNotPresentOnAllDaysWarning()
    func hideNotPresentOnAllDaysWarning()
    func showAfterDarkContentWarning()
    func hideAfterDarkContentWarning()

}
