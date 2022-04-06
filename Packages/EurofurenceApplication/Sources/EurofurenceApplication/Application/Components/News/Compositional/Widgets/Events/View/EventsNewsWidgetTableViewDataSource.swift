import Combine
import ComponentBase
import ScheduleComponent
import UIKit

public class EventsNewsWidgetTableViewDataSource<T>: NSObject, TableViewMediator where T: EventsWidgetViewModel {
    
    private let viewModel: T
    private var viewModelDidChange: Cancellable?
    
    public init(viewModel: T) {
        self.viewModel = viewModel
        
        super.init()
        
        viewModelDidChange = viewModel
            .objectDidChange
            .sink { [weak self] (_) in
                if let dataSource = self {
                    dataSource.delegate?.dataSourceContentsDidChange(dataSource)
                }
            }
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
        let cell = tableView.dequeue(EventTableViewCell.self, for: indexPath)
        cell.subscriptions.removeAll()
        
        let event = viewModel.event(at: indexPath.row)
        cell.setEventName(event.name)
        cell.setLocation(event.location)
        cell.setEventStartTime(event.startTime)
        cell.setEventEndTime(event.endTime)
        
        event
            .publisher(for: \.isFavourite)
            .sink { [weak cell] (isFavourite) in
                if isFavourite {
                    cell?.showFavouriteEventIndicator()
                } else {
                    cell?.hideFavouriteEventIndicator()
                }
            }
            .store(in: &cell.subscriptions)
        
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
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.eventSelected(at: indexPath.row)
    }
    
}
