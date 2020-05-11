import Foundation
import UIKit

public struct DefaultDownMarkdownRenderer: DownMarkdownRenderer {
    
    public init() {
        
    }
    
    // TODO: Use Swift's """ format for making this a pretty stylesheet.
    // swiftlint:disable line_length
    public var stylesheet: String? {
        let darkModeAccessor = UIView()
        
        let textColorName: String
        if #available(iOS 12.0, *), darkModeAccessor.traitCollection.userInterfaceStyle == .dark {
            textColorName = "white"
        } else {
            textColorName = "black"
        }
        
        return "* { font: -apple-system-body; color: \(textColorName); } h1, h2, h3, h4, h5, h6, strong { font-weight: bold; } em { font-style: italic; } h1 { font-size: 175%; } h2 { font-size: 150%; } h3 { font-size: 130%; } h4 { font-size: 115%; } h5 { font-style: italic; }"
    }

}
