import EurofurenceKit
import SwiftUI

struct MapView: View {
    
    @ObservedObject var map: Map
    @State private var selectedMapPosition: CGPoint?
    
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
                    let coordinate = CGPoint(
                        x: newValue.x * CGFloat(mapSize.width),
                        y: newValue.y * CGFloat(mapSize.height)
                    )
                    
                    print("*** loc: \(coordinate)")
                }
            }
        }
        // Keep the ZStack centered in the scene, regardless of whether the navigation bars are displayed
        .edgesIgnoringSafeArea(.all)
        .navigationBarTitleDisplayMode(.inline)
        .hideToolbarsWhenPanningLargerThanContainer()
        .navigationTitle(map.mapDescription)
    }
    
}

struct MapView_Previews: PreviewProvider {
    
    static var previews: some View {
        EurofurenceModel.preview { model in
            NavigationView {            
                MapView(map: model.map(for: .venue))
            }
        }
    }
    
}
