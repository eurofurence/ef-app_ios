import Combine
import ComponentBase
import UIKit

public class ConventionCountdownTableViewDataSource<
    ViewModel: ConventionCountdownViewModel
>: NSObject, TableViewMediator {
    
    private let viewModel: ViewModel
    private var subscriptions = Set<AnyCancellable>()
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init()
        
        viewModel
            .publisher(for: \.showCountdown)
            .sink { [weak self] (_) in
                if let self = self {
                    self.delegate?.dataSourceContentsDidChange(self)
                }
            }
            .store(in: &subscriptions)
    }
    
    public var delegate: TableViewMediatorDelegate?
    
    public func registerReusableViews(into tableView: UITableView) {
        tableView.registerConventionBrandedHeader()
        tableView.register(NewsConventionCountdownTableViewCell.self)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.showCountdown ? 1 : 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(NewsConventionCountdownTableViewCell.self)
        
        viewModel
            .publisher(for: \.countdownDescription)
            .map({ $0 ?? "" })
            .sink { [weak cell] (countdownDescription) in
                cell?.setTimeUntilConvention(countdownDescription)
            }
            .store(in: &subscriptions)
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueConventionBrandedHeader()
        headerView.textLabel?.text = .daysUntilConvention
        
        return headerView
    }
    
}
