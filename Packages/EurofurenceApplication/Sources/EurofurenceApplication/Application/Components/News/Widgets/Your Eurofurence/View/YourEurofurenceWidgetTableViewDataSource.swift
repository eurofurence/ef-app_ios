import Combine
import ComponentBase
import UIKit

public class YourEurofurenceWidgetTableViewDataSource<
    ViewModel: YourEurofurenceWidgetViewModel
>: NSObject, TableViewMediator {
    
    private let viewModel: ViewModel
    private var subscriptions = Set<AnyCancellable>()
    
    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init()
        
        viewModel
            .objectDidChange
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
        tableView.register(NewsUserWidgetTableViewCell.self)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(NewsUserWidgetTableViewCell.self)
        cell.bind(to: viewModel)
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueConventionBrandedHeader()
        headerView.textLabel?.text = .yourEurofurence
        
        return headerView
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.showPersonalisedContent()
    }
    
}
