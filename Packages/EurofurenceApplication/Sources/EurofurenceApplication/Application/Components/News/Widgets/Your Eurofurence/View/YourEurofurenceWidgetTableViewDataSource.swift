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
        bind(cell)
        
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
    
    private func bind(_ cell: NewsUserWidgetTableViewCell) {
        subscriptions.removeAll()
        
        viewModel
            .publisher(for: \.prompt)
            .map(Optional.init)
            .assign(to: \.text, on: cell.promptLabel)
            .store(in: &subscriptions)
        
        viewModel
            .publisher(for: \.supplementaryPrompt)
            .map(Optional.init)
            .assign(to: \.text, on: cell.detailedPromptLabel)
            .store(in: &subscriptions)
        
        viewModel
            .publisher(for: \.isHighlightedForAttention)
            .assign(to: \.isHidden, on: cell.standardUserPromptView)
            .store(in: &subscriptions)
        
        viewModel
            .publisher(for: \.isHighlightedForAttention)
            .map({ !$0 })
            .assign(to: \.isHidden, on: cell.highlightedUserPromptView)
            .store(in: &subscriptions)
        
        viewModel
            .publisher(for: \.isHighlightedForAttention)
            .map({ [weak cell] in $0 ? cell?.highlightedUserPromptColor : cell?.standardUserPromptColor })
            .assign(to: \.textColor, on: cell.detailedPromptLabel)
            .store(in: &subscriptions)
    }
    
}
