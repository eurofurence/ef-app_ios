import SwiftUI

struct FontAwesomeText: View {
    
    var unicodeCharacterAddress: String
    var size: CGFloat
    
    var body: some View {
        let unicodeString: String = {
            let rawMutable = NSMutableString(string: "\\u\(unicodeCharacterAddress)")
            CFStringTransform(rawMutable, nil, "Any-Hex/Java" as NSString, true)
            
            return rawMutable as String
        }()
        
        Text(unicodeString)
            .font(.custom("FontAwesome", size: size))
    }
    
}
