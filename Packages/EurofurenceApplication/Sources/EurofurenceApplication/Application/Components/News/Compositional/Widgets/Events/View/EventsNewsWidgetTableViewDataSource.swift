import ComponentBase
import ScheduleComponent
import UIKit

public class EventsNewsWidgetTableViewDataSource<T>: NSObject, TableViewMediator where T: EventsWidgetViewModel {
    
    private let viewModel: T
    
    public init(viewModel: T) {
        self.viewModel = viewModel
    }
    
    public weak var delegate: TableViewMediatorDelegate?
    
    public func registerReusableViews(into tableView: UITableView) {
        tableView.registerConventionBrandedHeader()
        EventTableViewCell.registerNib(in: tableView)
    }
    
    public func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        let headerView = tableView.dequeueConventionBrandedHeader()
        headerView.textLabel?.text = viewModel.title
        
        return headerView
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfEvents
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(EventTableViewCell.self)
        let event = viewModel.event(at: indexPath.row)
        cell.setEventName(event.name)
        cell.setLocation(event.location)
        cell.setEventStartTime(event.startTime)
        cell.setEventEndTime(event.endTime)
        
        if event.isFavourite {
            cell.showFavouriteEventIndicator()
        } else {
            cell.hideFavouriteEventIndicator()
        }
        
        if event.isSponsorOnly {
            cell.showSponsorEventIndicator()
        } else {
            cell.hideSponsorEventIndicator()
        }
        
        if event.isSuperSponsorOnly {
            cell.showSuperSponsorOnlyEventIndicator()
        } else {
            cell.hideSuperSponsorOnlyEventIndicator()
        }
        
        if event.isArtShow {
            cell.showArtShowEventIndicator()
        } else {
            cell.hideArtShowEventIndicator()
        }
        
        if event.isDealersDen {
            cell.showDealersDenEventIndicator()
        } else {
            cell.hideDealersDenEventIndicator()
        }
        
        if event.isMainStage {
            cell.showMainStageEventIndicator()
        } else {
            cell.hideMainStageEventIndicator()
        }
        
        if event.isPhotoshoot {
            cell.showPhotoshootStageEventIndicator()
        } else {
            cell.hidePhotoshootStageEventIndicator()
        }
        
        if event.isKageEvent {
            cell.showKageEventIndicator()
        } else {
            cell.hideKageEventIndicator()
        }
        
        return cell
    }
    
}
