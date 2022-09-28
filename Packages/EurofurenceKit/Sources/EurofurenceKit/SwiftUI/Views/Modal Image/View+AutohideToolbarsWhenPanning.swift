import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

extension View {
    
    @ViewBuilder
    public func hideToolbarsWhenPanningLargerThanContainer() -> some View {
#if os(iOS)
        if #available(iOS 16.0, *) {
            modifier(ModernBarHidingViewModifier())
        } else {
            modifier(LegacyBarHidingViewModifier())
        }
#else
        self
#endif
    }
    
}

#if canImport(UIKit)

@available(iOS 16.0, *)
private struct ModernBarHidingViewModifier: ViewModifier {
    
    @State private var hideBars: Bool = false
    
    func body(content: Content) -> some View {
        content
            .onPreferenceChange(IsPanningOutsideContainerPreferenceKey.self) { newValue in
                withAnimation {
                    hideBars = newValue
                }
            }
            .toolbar(hideBars ? .hidden : .automatic, for: .tabBar)
            .toolbar(hideBars ? .hidden : .automatic, for: .navigationBar)
    }
    
}

private struct LegacyBarHidingViewModifier: ViewModifier {
    
    @State private var hideBars: Bool = false
    @Environment(\.window) private var window
    
    func body(content: Content) -> some View {
        content
            .navigationTitle("")
            .navigationBarHidden(hideBars)
            .navigationBarBackButtonHidden(hideBars)
            .onPreferenceChange(IsPanningOutsideContainerPreferenceKey.self) { newValue in
                withAnimation {
                    hideBars = newValue
                }
            }
            .onChange(of: hideBars) { _ in
                updateTabBarVisibility()
            }
    }
    
    private func updateTabBarVisibility() {
        let tabBarController = window.rootViewController?.firstDescendent(ofType: UITabBarController.self)
        tabBarController?.tabBar.isHidden = hideBars
    }
    
}

#endif
