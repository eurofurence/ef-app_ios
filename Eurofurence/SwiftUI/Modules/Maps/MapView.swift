import EurofurenceKit
import SwiftUI

struct MapView: View {
    
    @ObservedObject var map: Map
    @State private var selectedMapPosition: CGPoint?
    @State private var visibleEntries: [Map.Entry] = []
    @State private var selectedEntry: Map.Entry?
    
    var body: some View {
        ZStack(alignment: .center) {
            if let mapImage = map.graphic.image {
                PannableView(
                    selectedProportionalLocation: $selectedMapPosition,
                    mapImage.resizable().aspectRatio(contentMode: .fit)
                )
                .onChange(of: selectedMapPosition) { newValue in
                    guard let newValue = newValue else { return }
                    
                    // The inbound location is a proportion. Scale it up to the real size of the map.
                    let mapSize = map.graphic.size
                    let coordinate = Map.Coordinate(
                        x: Int(newValue.x * CGFloat(mapSize.width)),
                        y: Int(newValue.y * CGFloat(mapSize.height))
                    )
                    
                    let entries = map.entries(at: coordinate)
                    if entries.count == 1, let first = entries.first {
                        selectedEntry = first
                    } else {
                        visibleEntries = entries
                    }
                }
            }
        }
        // Keep the ZStack centered in the scene, regardless of whether the navigation bars are displayed
        .edgesIgnoringSafeArea(.all)
        .navigationBarTitleDisplayMode(.inline)
        .hideToolbarsWhenPanningLargerThanContainer()
        .navigationTitle(map.mapDescription)
        .sheet(item: $selectedEntry) { entry in
            NavigationView {
                switch entry {
                case .dealer(let dealer):
                    DealerView(dealer: dealer)
                }
            }
        }
        .confirmationDialog("Select Option", isPresented: isDisambiguiatingEntrySelection) {
            ForEach(visibleEntries) { entry in
                Button {
                    selectedEntry = entry
                } label: {
                    Text(entry.title)
                }
            }
        }
    }
    
    private var isDisambiguiatingEntrySelection: Binding<Bool> {
        Binding {
            visibleEntries.count > 1
        } set: { _ in
            visibleEntries = []
        }
    }
    
}

struct MapView_Previews: PreviewProvider {
    
    static var previews: some View {
        EurofurenceModel.preview { model in
            NavigationView {            
                MapView(map: model.map(for: .venue))
            }
            .previewDisplayName("Venue")
            
            NavigationView {
                MapView(map: model.map(for: .dealersDen))
            }
            .previewDisplayName("Dealers")
        }
    }
    
}
