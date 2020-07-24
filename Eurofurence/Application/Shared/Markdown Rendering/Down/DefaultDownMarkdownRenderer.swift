import Down
import Foundation
import UIKit

struct DefaultDownMarkdownRenderer: MarkdownRenderer {
    
    private let processor: DownProcessor
    
    init() {
        var fontCollection = StaticFontCollection()
        fontCollection.body = UIFont.preferredFont(forTextStyle: .body)
        
        var colorCollection = StaticColorCollection()
        
        let textColor: UIColor
        if #available(iOS 13.0, *) {
            textColor = .label
        } else {
            textColor = .black
        }
        
        colorCollection.heading1 = textColor
        colorCollection.heading2 = textColor
        colorCollection.heading3 = textColor
        colorCollection.heading4 = textColor
        colorCollection.heading5 = textColor
        colorCollection.heading6 = textColor
        colorCollection.body = textColor
        colorCollection.listItemPrefix = textColor
        
        var paragraphStyles = StaticParagraphStyleCollection()
        let bodyStyle = NSMutableParagraphStyle()
        bodyStyle.paragraphSpacingBefore = 8
        bodyStyle.paragraphSpacing = 8
        paragraphStyles.body = bodyStyle
        
        let styler = DownStyler(configuration: DownStylerConfiguration(
            fonts: fontCollection,
            colors: colorCollection,
            paragraphStyles: paragraphStyles,
            listItemOptions: ListItemOptions(),
            quoteStripeOptions: QuoteStripeOptions(),
            thematicBreakOptions: ThematicBreakOptions(),
            codeBlockOptions: CodeBlockOptions()
        ))
        
        processor = DownProcessor(styler: styler)
    }
    
    func render(_ contents: String) -> NSAttributedString {
        processor.convertMarkdownToAttributedString(markdown: contents)
    }

}
