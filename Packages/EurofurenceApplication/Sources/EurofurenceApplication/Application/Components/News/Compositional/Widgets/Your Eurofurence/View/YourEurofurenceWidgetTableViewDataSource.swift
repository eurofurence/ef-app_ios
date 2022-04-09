import UIKit

public class YourEurofurenceWidgetTableViewDataSource<
    ViewModel: YourEurofurenceWidgetViewModel
>: NSObject, TableViewMediator {
    
    private let viewModel: ViewModel
    
    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    public var delegate: TableViewMediatorDelegate?
    
    public func registerReusableViews(into tableView: UITableView) {
        tableView.register(NewsUserWidgetTableViewCell.self)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(NewsUserWidgetTableViewCell.self)
        cell.setPrompt(viewModel.prompt)
        cell.setDetailedPrompt(viewModel.supplementaryPrompt)
        
        if viewModel.isHighlightedForAttention {
            cell.hideStandardUserPrompt()
            cell.showHighlightedUserPrompt()
        } else {
            cell.showStandardUserPrompt()
            cell.hideHighlightedUserPrompt()
        }
        
        return cell
    }
    
}
