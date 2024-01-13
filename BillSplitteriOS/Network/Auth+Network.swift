//
//  Auth+Network.swift
//  BillSplitteriOS
//
//  Created by Temur on 01/01/2024.
//

import Foundation
import Alamofire
extension Network {
    func authorization(username:String, email: String, password:String, completion: @escaping (StatusCode) -> ()) {
        
        //Api
        let api:Api = Api.login
        
        //Body
        let parameters = [
            [
                "key": "username",
                "value": username,
                "type": "text"
            ],
            [
                "key": "email",
                "value": email,
                "type": "text"
            ],
            [
                "key": "password",
                "value": password,
                "type": "text"
            ]] as [[String : String]]
        
        
        //Header
        let boundary = generateBoundaryString()
        let body = generateMutableData(boundary: boundary, parameters: parameters, imagesData: []) as Data
        
        print(String(data: body, encoding: .utf8)!)
        push(false, api: api, body: body, headers: nil, type: AuthToken.self) { result in
            switch result {
            case .success(let model):
                guard let token = model.body?.token else {
                    completion(StatusCode(code: 403, message: model.message))
                    return
                }
                
                let auth = AuthApp.shared
                auth.token = token
                auth.autorization = AuthData(username: username, email: email, password: password)
                completion(StatusCode(code: 0))
                
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    func authorizationAF(username:String, email: String, password:String, completion: @escaping (StatusCode) -> ()) {
        let api = Api.login
        let login = AuthData(username: username, email: email, password: password)
        let headers: HTTPHeaders = [
            .accept("application/json")
        ]
        
        AF.request(api.path, method: .post, parameters: login, encoder: JSONParameterEncoder.default, headers: headers).response { data in
            guard data.error == nil else {
                completion(StatusCode(data.error))
                return
            }
            completion(StatusCode(code: data.response?.statusCode ?? 0))
        }
    }
}
