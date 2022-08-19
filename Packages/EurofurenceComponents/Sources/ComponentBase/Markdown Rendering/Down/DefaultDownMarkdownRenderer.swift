import Down
import Foundation
import UIKit

public struct DefaultDownMarkdownRenderer: MarkdownRenderer {
    
    private let processor: DownProcessor
    
    private static var fonts: FontCollection {
        var fontCollection = StaticFontCollection()
        fontCollection.body = UIFont.preferredFont(forTextStyle: .body)
        
        return fontCollection
    }
    
    private static var colors: ColorCollection {
        var colorCollection = StaticColorCollection()
        
        let textColor: UIColor = .label
        colorCollection.body = textColor
        colorCollection.code = textColor
        colorCollection.heading1 = textColor
        colorCollection.heading2 = textColor
        colorCollection.heading3 = textColor
        colorCollection.heading4 = textColor
        colorCollection.heading5 = textColor
        colorCollection.heading6 = textColor
        colorCollection.listItemPrefix = textColor
        
        return colorCollection
    }
    
    private static var paragraphStyles: ParagraphStyleCollection {
        var paragraphStyles = StaticParagraphStyleCollection()
        let bodyStyle = NSMutableParagraphStyle()
        bodyStyle.paragraphSpacingBefore = 8
        bodyStyle.paragraphSpacing = 8
        paragraphStyles.body = bodyStyle
        
        return paragraphStyles
    }
    
    public init() {
        let styler = DownStyler(configuration: DownStylerConfiguration(
            fonts: Self.fonts,
            colors: Self.colors,
            paragraphStyles: Self.paragraphStyles,
            listItemOptions: ListItemOptions(),
            quoteStripeOptions: QuoteStripeOptions(),
            thematicBreakOptions: ThematicBreakOptions(),
            codeBlockOptions: CodeBlockOptions()
        ))
        
        processor = DownProcessor(styler: styler)
    }
    
    public func render(_ contents: String) -> NSAttributedString {
        processor.convertMarkdownToAttributedString(markdown: contents)
    }

}
