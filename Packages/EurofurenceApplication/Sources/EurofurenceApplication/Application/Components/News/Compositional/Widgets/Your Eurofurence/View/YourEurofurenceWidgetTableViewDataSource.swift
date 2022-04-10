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
        
        viewModel
            .publisher(for: \.prompt)
            .sink { [weak cell] (prompt) in
                cell?.setPrompt(prompt)
            }
            .store(in: &subscriptions)
        
        viewModel
            .publisher(for: \.supplementaryPrompt)
            .sink { [weak cell] (supplementaryPrompt) in
                cell?.setDetailedPrompt(supplementaryPrompt)
            }
            .store(in: &subscriptions)
        
        viewModel
            .publisher(for: \.isHighlightedForAttention)
            .sink { [weak cell] (isHighlightedForAttention) in
                if isHighlightedForAttention {
                    cell?.hideStandardUserPrompt()
                    cell?.showHighlightedUserPrompt()
                } else {
                    cell?.showStandardUserPrompt()
                    cell?.hideHighlightedUserPrompt()
                }
            }
            .store(in: &subscriptions)
        
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
