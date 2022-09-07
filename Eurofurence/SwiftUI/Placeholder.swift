import EurofurenceKit
import SwiftUI

struct Placeholder: View {
    
    @FetchRequest(
        entity: Event.entity(),
        sortDescriptors: [NSSortDescriptor(key: "startDate", ascending: true)]
    )
    private var events: FetchedResults<Event>
    
    var body: some View {
        List(events) { event in
            Text(event.title)
        }
    }
    
}

struct Placeholder_Previews: PreviewProvider {
    
    static var previews: some View {
        let preview: EurofurenceModel = .preview()
        Placeholder()
            .environmentModel(preview)
    }
    
}
