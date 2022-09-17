import EurofurenceKit
import SwiftUI

struct FavouriteEventsNavigationLink: View {
    
    @EnvironmentObject private var model: EurofurenceModel
    
    var body: some View {
        NavigationLink {
            let favouritesOnly = EurofurenceModel.ScheduleConfiguration(favouritesOnly: true)
            ScheduleCollectionView(schedule: model.makeSchedule(configuration: favouritesOnly))
                .showScheduleFilter(false)
                .navigationTitle("Favourited Events")
        } label: {
            Label {
                Text("Favourite Events")
            } icon: {
                FavouriteIcon(filled: true)
            }
        }
    }
    
}
