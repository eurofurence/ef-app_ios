import EurofurenceKit
import SwiftUI

struct ToggleEventFavouriteStateButton<Icon>: View where Icon: View {
    
    @ObservedObject private var event: Event
    @Environment(\.selectionChangedHaptic) private var selectionChangedHaptic
    private let icon: () -> Icon
    
    init(event: Event, @ViewBuilder _ icon: @escaping () -> Icon) {
        self.event = event
        self.icon = icon
    }
    
    var body: some View {
        Button {
            selectionChangedHaptic()
            
            Task {
                if event.isFavourite {
                    await event.unfavourite()
                } else {
                    await event.favourite()
                }
            }
        } label: {
            Label {
                Text(event.isFavourite ? "Unfavourite" : "Favourite")
            } icon: {
                icon()
            }
        }
    }
    
}
