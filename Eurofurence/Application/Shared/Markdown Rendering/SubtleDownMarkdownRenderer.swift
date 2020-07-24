import Down
import Foundation

struct SubtleDownMarkdownRenderer: MarkdownRenderer {
    
    private let styler: Styler
    
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
