import Foundation
import UIKit

public class AnnouncementsNewsWidgetTableViewDataSource<
    ViewModel: NewsAnnouncementsWidgetViewModel
>: NSObject, TableViewMediator {
    
    private let viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    public var delegate: TableViewMediatorDelegate?
    
    public func registerReusableViews(into tableView: UITableView) {
        tableView.registerConventionBrandedHeader()
        tableView.register(ViewAllAnnouncementsTableViewCell.self)
        tableView.register(AnnouncementTableViewCell.self)
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueConventionBrandedHeader()
        headerView.textLabel?.text = .announcements
        
        return headerView
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfElements
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let visualElement = viewModel.element(at: indexPath.row)
        let cell: UITableViewCell
        
        switch visualElement {
        case .showMoreAnnouncements:
            let moreAnnouncementsCell = tableView.dequeue(ViewAllAnnouncementsTableViewCell.self)
            moreAnnouncementsCell.showCaption(.allAnnouncements)
            cell = moreAnnouncementsCell
            
        case .announcement(let announcement):
            let announcementCell = tableView.dequeue(AnnouncementTableViewCell.self)
            announcementCell.setAnnouncementReceivedDateTime(announcement.formattedTimestamp)
            announcementCell.setAnnouncementTitle(announcement.title)
            announcementCell.setAnnouncementDetail(announcement.body)
            
            announcement
                .publisher(for: \.isUnreadIndicatorVisible)
                .sink { [weak announcementCell] (isUnreadIndicatorVisible) in
                    if isUnreadIndicatorVisible {
                        announcementCell?.showUnreadIndicator()
                    } else {
                        announcementCell?.hideUnreadIndicator()
                    }
                }
                .store(in: &announcementCell.subscriptions)
            
            cell = announcementCell
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let visualElement = viewModel.element(at: indexPath.row)
        
        switch visualElement {
        case .showMoreAnnouncements:
            viewModel.openAllAnnouncements()
            
        case .announcement(let announcement):
            announcement.open()
        }
    }
    
}
