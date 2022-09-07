import EurofurenceKit

struct AppModel {
    
    static let shared = AppModel()
    let model: EurofurenceModel
    
    private init() {
        model = EurofurenceModel()
    }
    
}
