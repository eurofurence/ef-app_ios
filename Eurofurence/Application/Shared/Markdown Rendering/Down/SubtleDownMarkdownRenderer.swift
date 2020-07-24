import Down
import Foundation

struct SubtleDownMarkdownRenderer: MarkdownRenderer {
    
    private let processor: DownProcessor
    
    init() {
        var fontCollection = StaticFontCollection()
        fontCollection.body = UIFont.preferredFont(forTextStyle: .caption1)
        
        var colorCollection = StaticColorCollection()
        colorCollection.body = UIColor(red: 0.498, green: 0.498, blue: 0.498, alpha: 1)
        
        var paragraphStyles = StaticParagraphStyleCollection()
        let bodyParagraphStyle = (paragraphStyles.body.mutableCopy() as? NSMutableParagraphStyle).unsafelyUnwrapped
        bodyParagraphStyle.paragraphSpacingBefore = 0
        bodyParagraphStyle.paragraphSpacing = 0
        paragraphStyles.body = bodyParagraphStyle
        
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
