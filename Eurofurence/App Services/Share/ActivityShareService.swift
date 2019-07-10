import UIKit

struct ActivityShareService: ShareService {
    
    func share(_ item: Any, sender: Any) {
        let app = UIApplication.shared
        guard let optionalWindow = app.delegate?.window,
              let window = optionalWindow,
              let rootViewController = window.rootViewController,
              let sender = sender as? UIView else { return }
        
        let senderFrame = sender.frame
        let senderCenter = CGPoint(x: senderFrame.width / 2, y: senderFrame.height / 2)
        let activityViewController = UIActivityViewController(activityItems: [item], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = sender
        activityViewController.popoverPresentationController?.sourceRect = CGRect(origin: senderCenter, size: .zero)
        
        rootViewController.present(activityViewController, animated: true)
    }
    
}
