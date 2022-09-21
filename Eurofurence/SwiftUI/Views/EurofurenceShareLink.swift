#if canImport(AppKit)
import AppKit
#endif
import EurofurenceKit
import LinkPresentation
import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

/// A platform and OS-version sensitive view for sharing content expressible by a URL.
struct EurofurenceShareLink: View {
    
    var url: URL
    var title: String
    
    var body: some View {
        if #available(iOS 16.0, *) {
            ModernShareLink(url: url, title: title)
        } else {
            LegacyShareLink(url: url, title: title)
        }
    }
    
}

@available(iOS 16.0, *)
private struct ModernShareLink: View {
    
    var url: URL
    var title: String
    
    var body: some View {
        ShareLink(
            item: url,
            subject: Text(title)
        )
    }
    
}

private struct LegacyShareLink: View {
    
    var url: URL
    var title: String
    @State private var isPresentingShareSheet = false
    @State private var globalPosition: CGRect = .zero
    
    var body: some View {
        Button {
#if os(iOS)
            isPresentingShareSheet = true
#elseif os(macOS)
            #warning("Not implemented! Use NSSharingServicePicker.")
#endif
        } label: {
            Label {
                Text("Share")
            } icon: {
                Image(systemName: "square.and.arrow.up")
            }
        }
        .coordinates(in: .global) { newCoordinates in
            globalPosition = newCoordinates
        }
#if os(iOS)
        .popover(isPresented: $isPresentingShareSheet) {
            ActivityViewControllerRepresentable(url: url, title: title, origin: globalPosition)
        }
#endif
    }
    
#if os(iOS)
    private struct ActivityViewControllerRepresentable: UIViewControllerRepresentable {
        
        var url: URL
        var title: String
        var origin: CGRect
        @Environment(\.window) private var window
        
        typealias UIViewControllerType = UIActivityViewController
        
        func makeUIViewController(context: Context) -> UIViewControllerType {
            let activityItem = EurofurenceActivityItem(url: url, title: title)
            let viewController = UIActivityViewController(activityItems: [activityItem], applicationActivities: nil)
            viewController.modalPresentationStyle = .popover
            viewController.popoverPresentationController?.sourceView = window
            viewController.popoverPresentationController?.sourceRect = origin
            
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
        
        private class EurofurenceActivityItem: NSObject, UIActivityItemSource {
            
            private let url: URL
            private let title: String
            
            init(url: URL, title: String) {
                self.url = url
                self.title = title
            }
            
            func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
                url
            }
            
            func activityViewController(
                _ activityViewController: UIActivityViewController,
                itemForActivityType activityType: UIActivity.ActivityType?
            ) -> Any? {
                url
            }
            
            func activityViewControllerLinkMetadata(
                _ activityViewController: UIActivityViewController
            ) -> LPLinkMetadata? {
                let metadata = LPLinkMetadata()
                metadata.url = url
                metadata.title = title
                
                if let appIcon = UIImage(named: "Eurofurence Link Metadata Share Icon") {
                    metadata.iconProvider = NSItemProvider(object: appIcon)
                }
                
                return metadata
            }
            
        }
        
    }
#endif // os(iOS)
    
}
