import ScheduleComponent
import UIKit

public class EventsNewsWidgetTableViewDataSource<T>: NSObject, TableViewMediator where T: EventsWidgetViewModel {
    
    private let viewModel: T
    
    public init(viewModel: T) {
        self.viewModel = viewModel
    }
    
    public func registerReusableViews(into tableView: UITableView) {
        EventTableViewCell.registerNib(in: tableView)
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
        
        return cell
    }
    
}
