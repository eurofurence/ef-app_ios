struct AnyContentRoute {
    
    private let performRoute: (Any) -> Void
    
    init<Route>(_ route: Route) where Route: ContentRoute {
        performRoute = { (content) in
            if let content = content as? Route.Content {
                route.route(content)
            }
        }
    }
    
    func route(_ content: Any) {
        performRoute(content)
    }
    
}
