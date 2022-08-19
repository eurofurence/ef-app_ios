import Down
import UIKit

public struct SubtleDownMarkdownRenderer: MarkdownRenderer {
    
    private let processor: DownProcessor
    
    private static var fonts: FontCollection {
        var fontCollection = StaticFontCollection()
        let sharedFont = UIFont.preferredFont(forTextStyle: .caption1)
        fontCollection.body = sharedFont
        fontCollection.code = fontCollection.code.withSize(sharedFont.pointSize)
        fontCollection.heading1 = sharedFont
        fontCollection.heading2 = sharedFont
        fontCollection.heading3 = sharedFont
        fontCollection.heading4 = sharedFont
        fontCollection.heading5 = sharedFont
        fontCollection.heading6 = sharedFont
        
        return fontCollection
    }
    
    private static var colors: ColorCollection {
        var colorCollection = StaticColorCollection()
        let sharedColor = UIColor(red: 0.498, green: 0.498, blue: 0.498, alpha: 1)
        colorCollection.body = sharedColor
        colorCollection.code = sharedColor
        colorCollection.heading1 = sharedColor
        colorCollection.heading2 = sharedColor
        colorCollection.heading3 = sharedColor
        colorCollection.heading4 = sharedColor
        colorCollection.heading5 = sharedColor
        colorCollection.heading6 = sharedColor
        colorCollection.listItemPrefix = sharedColor
        colorCollection.quote = sharedColor
        colorCollection.quoteStripe = sharedColor
        
        return colorCollection
    }
    
    private static var paragraphStyles: ParagraphStyleCollection {
        var paragraphStyles = StaticParagraphStyleCollection()
        let sharedParagraphStyle = (paragraphStyles.body.mutableCopy() as? NSMutableParagraphStyle).unsafelyUnwrapped
        sharedParagraphStyle.paragraphSpacingBefore = 0
        sharedParagraphStyle.paragraphSpacing = 0
        sharedParagraphStyle.lineSpacing = 3
        paragraphStyles.body = sharedParagraphStyle
        paragraphStyles.code = sharedParagraphStyle
        paragraphStyles.heading1 = sharedParagraphStyle
        paragraphStyles.heading2 = sharedParagraphStyle
        paragraphStyles.heading3 = sharedParagraphStyle
        paragraphStyles.heading4 = sharedParagraphStyle
        paragraphStyles.heading5 = sharedParagraphStyle
        paragraphStyles.heading6 = sharedParagraphStyle
        
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
