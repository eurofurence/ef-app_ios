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
        let event = viewModel.event(at: indexPath.row)
        ViewModelBinder(cell: cell, event: event).bind()
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.eventSelected(at: indexPath.row)
    }
    
    private struct ViewModelBinder {
        
        let cell: EventTableViewCell
        let event: T.Event
        
        func bind() {
            removeExistingSubscriptions()
            bindPrimaryAttributes()
            bindEventTypeIndicators()
            bindFavouriteStatus()
        }
        
        private func removeExistingSubscriptions() {
            cell.subscriptions.removeAll()
        }
        
        private func bindPrimaryAttributes() {
            cell.setEventName(event.name)
            cell.setLocation(event.location)
            cell.setEventStartTime(event.startTime)
            cell.setEventEndTime(event.endTime)
        }
        
        private func bindEventTypeIndicators() {
            bindSponsorOnlyIndicator()
            bindSuperSponsorOnlyIndicator()
            bindArtShowIndicator()
            bindDealersDenIndicator()
            bindMainStageIndicator()
            bindPhotoshootIndicator()
            bindKageEventIndicator()
            bindFaceMaskStatus()
        }
        
        private func bindSponsorOnlyIndicator() {
            if event.isSponsorOnly {
                cell.showSponsorEventIndicator()
            } else {
                cell.hideSponsorEventIndicator()
            }
        }
        
        private func bindSuperSponsorOnlyIndicator() {
            if event.isSuperSponsorOnly {
                cell.showSuperSponsorOnlyEventIndicator()
            } else {
                cell.hideSuperSponsorOnlyEventIndicator()
            }
        }
        
        private func bindArtShowIndicator() {
            if event.isArtShow {
                cell.showArtShowEventIndicator()
            } else {
                cell.hideArtShowEventIndicator()
            }
        }
        
        private func bindDealersDenIndicator() {
            if event.isDealersDen {
                cell.showDealersDenEventIndicator()
            } else {
                cell.hideDealersDenEventIndicator()
            }
        }
        
        private func bindMainStageIndicator() {
            if event.isMainStage {
                cell.showMainStageEventIndicator()
            } else {
                cell.hideMainStageEventIndicator()
            }
        }
        
        private func bindPhotoshootIndicator() {
            if event.isPhotoshoot {
                cell.showPhotoshootStageEventIndicator()
            } else {
                cell.hidePhotoshootStageEventIndicator()
            }
        }
        
        private func bindKageEventIndicator() {
            if event.isKageEvent {
                cell.showKageEventIndicator()
            } else {
                cell.hideKageEventIndicator()
            }
        }
        
        private func bindFavouriteStatus() {
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
        }
        
        private func bindFaceMaskStatus() {
            if event.isFaceMaskRequired {
                cell.showFaceMaskRequiredIndicator()
            } else {
                cell.hideFaceMaskRequiredIndicator()
            }
        }
        
    }
    
}
