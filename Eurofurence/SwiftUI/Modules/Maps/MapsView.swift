import EurofurenceKit
import SwiftUI

struct MapsView: View {
    
    @FetchRequest(entity: Map.entity(), sortDescriptors: [NSSortDescriptor(key: "order", ascending: true)])
    private var maps: FetchedResults<Map>
    
    var body: some View {
        List {
            ForEach(maps) { map in
                NavigationLink {
                    MapView(map: map)
                } label: {
                    Text(map.mapDescription)
                }
            }
        }
        .navigationTitle("Maps")
    }
    
}

struct MapsView_Previews: PreviewProvider {
    
    static var previews: some View {
        EurofurenceModel.preview { _ in
            NavigationView {
                MapsView()
            }
        }
    }
    
}
