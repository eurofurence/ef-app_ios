import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

extension Color {
    
    static var formHeading: Color {
#if canImport(UIKit)
        return Color(uiColor: .systemGroupedBackground)
#else
        return .clear
#endif
    }
    
}
