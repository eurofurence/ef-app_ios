import EurofurenceApplication

class CapturingTableViewMediatorDelegate: TableViewMediatorDelegate {
    
    private(set) var contentsDidChange = false
    func dataSourceContentsDidChange(_ dataSource: TableViewMediator) {
        contentsDidChange = true
    }
    
}
