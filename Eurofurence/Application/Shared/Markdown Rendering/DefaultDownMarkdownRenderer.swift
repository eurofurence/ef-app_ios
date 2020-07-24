import Down
import Foundation
import UIKit

struct DefaultDownMarkdownRenderer: MarkdownRenderer {
    
    private let styler: Styler
    
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
        
        colorCollection.body = textColor
        colorCollection.listItemPrefix = textColor
        
        var paragraphStyles = StaticParagraphStyleCollection()
        let bodyStyle = NSMutableParagraphStyle()
        bodyStyle.paragraphSpacingBefore = 8
        bodyStyle.paragraphSpacing = 8
        paragraphStyles.body = bodyStyle
        
        styler = DownStyler(configuration: DownStylerConfiguration(
            fonts: fontCollection,
            colors: colorCollection,
            paragraphStyles: paragraphStyles,
            listItemOptions: ListItemOptions(),
            quoteStripeOptions: QuoteStripeOptions(),
            thematicBreakOptions: ThematicBreakOptions(),
            codeBlockOptions: CodeBlockOptions()
        ))
    }
    
    func render(_ contents: String) -> NSAttributedString {
        let down = Down(markdownString: contents)
        do {
            let attributedString = try down.toAttributedString(DownOptions.smart, styler: styler)
            return attributedString.attributedStringByTrimming(with: CharacterSet.whitespacesAndNewlines)
        } catch {
            return NSAttributedString(string: contents)
        }
    }

}
