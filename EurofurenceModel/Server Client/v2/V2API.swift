//
//  V2API.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 20/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

public struct V2API: ImageAPI, LoginAPI {

    // MARK: Properties

    private let jsonSession: JSONSession
    let apiUrl: String
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    // MARK: Initialization

    public init(jsonSession: JSONSession, apiUrl: V2ApiUrlProviding) {
        self.jsonSession = jsonSession
        self.apiUrl = apiUrl.url

        // TODO: Investigate why system ios8601 formatter fails to parse our dates
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(Iso8601DateFormatter())

        encoder = JSONEncoder()
    }

    // MARK: LoginAPI

    public func performLogin(request: LoginRequest, completionHandler: @escaping (LoginResponse?) -> Void) {
        let url = apiUrl + "Tokens/RegSys"
        let jsonData = try! encoder.encode(Request.APILogin(from: request))
        let jsonRequest = JSONRequest(url: url, body: jsonData)
        jsonSession.post(jsonRequest) { (data, _) in
            if let data = data, let response = try? self.decoder.decode(Response.APILogin.self, from: data) {
                completionHandler(response.makeDomainLoginResponse())
            } else {
                completionHandler(nil)
            }
        }
    }
    
    // MARK: ImageAPI
    
    public func fetchImage(identifier: String, completionHandler: @escaping (Data?) -> Void) {
        let url = apiUrl + "Images/\(identifier)/Content"
        let request = JSONRequest(url: url, body: Data())
        jsonSession.get(request) { (data, _) in
            completionHandler(data)
        }
    }

    // MARK: Private
    
    private struct Request {
        
        struct APILogin: Encodable {
            var RegNo: Int
            var Username: String
            var Password: String
            
            init(from request: LoginRequest) {
                RegNo = request.regNo
                Username = request.username
                Password = request.password
            }
        }
        
    }
    
    private struct Response {
        
        struct APILogin: Decodable {
            var Uid: String
            var Username: String
            var Token: String
            var TokenValidUntil: Date
            
            func makeDomainLoginResponse() -> LoginResponse {
                return LoginResponse(userIdentifier: Uid,
                                     username: Username,
                                     token: Token,
                                     tokenValidUntil: TokenValidUntil)
            }
        }
        
    }

}
