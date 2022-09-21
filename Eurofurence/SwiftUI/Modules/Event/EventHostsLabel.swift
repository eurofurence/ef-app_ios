import EurofurenceKit
import SwiftUI

struct EventHostsLabel: View {
    
    private static let formatter = ListFormatter()
    @ObservedObject private var event: Event
    
    init(_ event: Event) {
        self.event = event
    }
    
    var body: some View {
        Label {
            Text(verbatim: formattedHostsDescription)
        } icon: {
            Image(systemName: "person.circle")
        }
    }
    
    private var formattedHostsDescription: String {
        Self.formatter.string(from: event.panelHosts.map(\.name)) ?? ""
    }
    
}

struct EventHostsLabel_Previews: PreviewProvider {
    
    static var previews: some View {
        EurofurenceModel.preview { model in
            let dealersDen: Event = model.event(for: .dealersDen)
            EventHostsLabel(dealersDen)
                .previewDisplayName(dealersDen.title)
                .previewLayout(.sizeThatFits)
            
            let bootyBounce: Event = model.event(for: .bootyBounce)
            EventHostsLabel(bootyBounce)
                .previewDisplayName(bootyBounce.title)
                .previewLayout(.sizeThatFits)
            
            let deadDog = model.event(for: .deadDog)
            EventHostsLabel(deadDog)
                .previewDisplayName(deadDog.title)
                .previewLayout(.sizeThatFits)
        }
    }
    
}
