//
//  Auth+Network.swift
//  BillSplitteriOS
//
//  Created by Temur on 01/01/2024.
//

import Foundation
import Alamofire
extension Network {
    func authorizationAF(username:String, email: String, password:String, completion: @escaping (StatusCode, String?) -> ()) {
        let api = Api.signUp
        let authData = AuthData(user: AuthUser(username: username, email: email, password: password))
        let headers: HTTPHeaders = [
            .contentType("application/json")
        ]
        
        AF.request(api.path, method: .post, parameters: authData, encoder: JSONParameterEncoder.default, headers: headers).response { data in
            guard data.error == nil, let body = data.data else {
                completion(StatusCode(data.error), nil)
                return
            }
            if let decodedData = try? JSONDecoder().decode(AuthResponseBody.self, from: body) {
                AuthApp.shared.token = decodedData.jwt_token
                completion(StatusCode(code: data.response?.statusCode ?? 0), decodedData.jwt_token)
            }else {
                completion(StatusCode(NSError(domain: "Cannot parse data", code: 0)), nil)
            }
            
            
        }
    }
    
    func signIn(username: String, password: String, completion: @escaping (StatusCode, String?) -> ()) {
        let api = Api.signIn
        
        struct User: Encodable {
            let username: String
            let password: String
        }
        struct SignInModel: Encodable {
            let user: User
        }
        let body = SignInModel(user: User(username: username, password: password))
        
        AF.request(api.path, method: api.method, parameters: body)
            .response { response in
                guard response.error == nil, let body = response.data else {
                    completion(StatusCode(response.error), nil)
                    return
                }
                
                if let decodedData = try? JSONDecoder().decode(AuthResponseBody.self, from: body) {
                    AuthApp.shared.token = decodedData.jwt_token
                    completion(StatusCode(code: response.response?.statusCode ?? 0), decodedData.jwt_token)
                }else {
                    completion(StatusCode(NSError(domain: "Cannot parse data", code: 0)), nil)
                }
            }
        
    }
}
