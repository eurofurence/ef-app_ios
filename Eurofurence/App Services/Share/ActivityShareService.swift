import UIKit

struct ActivityShareService: ShareService {
    
    var window: UIWindow
    
    func share(_ item: Any, sender: Any) {
        guard let rootViewController = window.rootViewController else { return }
        
        let activityViewController = UIActivityViewController(activityItems: [item], applicationActivities: nil)
        
        if let sender = sender as? UIView {
            let senderFrame = sender.frame
            let senderCenter = CGPoint(x: senderFrame.width / 2, y: senderFrame.height / 2)
            activityViewController.popoverPresentationController?.sourceView = sender
            activityViewController.popoverPresentationController?.sourceRect = CGRect(origin: senderCenter, size: .zero)
        }
        
        if let sender = sender as? UIBarButtonItem {
            activityViewController.popoverPresentationController?.barButtonItem = sender
        }
        
        rootViewController.present(activityViewController, animated: true)
    }
    
}
