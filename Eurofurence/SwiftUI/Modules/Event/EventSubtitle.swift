import EurofurenceKit
import SwiftUI

struct EventSubtitle: View {
    
    @ObservedObject private var event: Event
    
    init(_ event: Event) {
        self.event = event
    }
    
    var body: some View {
        if event.subtitle.isEmpty {
            if let abstract = event.abstract {
                MarkdownContent(abstract)
            }
        } else {
            MarkdownContent(event.subtitle)
        }
    }
    
}

struct EventSubtitle_Previews: PreviewProvider {
    
    static var previews: some View {
        EurofurenceModel.preview { model in
            let registration = model.event(for: .registration)
            EventSubtitle(registration)
                .previewDisplayName(registration.title)
                .previewLayout(.sizeThatFits)
            
            let bootyBounce = model.event(for: .bootyBounce)
            EventSubtitle(bootyBounce)
                .previewDisplayName(bootyBounce.title)
                .previewLayout(.sizeThatFits)
        }
    }
    
}
