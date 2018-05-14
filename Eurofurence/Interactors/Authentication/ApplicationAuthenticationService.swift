//
//  ApplicationAuthenticationService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

class ApplicationAuthenticationService: AuthenticationService {

    static let shared = ApplicationAuthenticationService(app: EurofurenceApplication.shared)

    private let app: EurofurenceApplicationProtocol
    private var observers = [AuthenticationStateObserver]()

    init(app: EurofurenceApplicationProtocol) {
        self.app = app
    }

    func add(observer: AuthenticationStateObserver) {
        observers.append(observer)
    }

    func perform(_ request: LoginArguments, completionHandler: @escaping (LoginServiceResult) -> Void) {
        app.login(request) { (result) in
            switch result {
            case .success(let user):
                completionHandler(.success)
                self.observers.forEach { $0.userDidLogin(user) }

            case .failure:
                completionHandler(.failure)
            }
        }
    }

}
