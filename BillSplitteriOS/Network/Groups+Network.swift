//
//  Groups+Network.swift
//  BillSplitteriOS
//
//  Created by Temur on 01/01/2024.
//

import Foundation
import Alamofire
extension Network {
    func createGroup(name: String, completion: @escaping (StatusCode, GroupModel?) -> ()) {
        
        //Api
        let api:Api = Api.createGroup
        let token = AuthApp.shared.token ?? ""
        let headers: HTTPHeaders = [
            .authorization(bearerToken: token)
        ]
        struct Group: Encodable {
            let name: String
        }
        
        struct Wrap: Encodable {
            let group: Group
        }
        
        let body = Wrap(group: Group(name: name))
        
        AF.request(api.path, method: api.method, parameters: body, headers: headers).response { response in
            
            guard response.error == nil, let data = response.data else {
                completion(StatusCode(response.error), nil)
                return
            }
            if !Network.checkForAuth(data: data) {
                completion(StatusCode(code: 0, message: "Auth requested!"), nil)
                return
            }
            if let decodedData = try? JSONDecoder().decode([GroupModel].self, from: data) {
                completion(StatusCode(code: response.response?.statusCode ?? 0), decodedData.first!)
            }else {
                completion(StatusCode(NSError(domain: "Cannot parse data", code: 0)), nil)
            }
        }
    }
    
    func getGroups(completion: @escaping (StatusCode, [GroupModel]?) -> ()) {
        
        let api = Api.groups
        let token = AuthApp.shared.token ?? ""
        let headers: HTTPHeaders = [
            .authorization(bearerToken: token)
        ]
        
        AF.request(api.path, method: api.method, headers: headers)
            .response { response in
            
            guard response.error == nil, let data = response.data else {
                completion(StatusCode(response.error), nil)
                return
            }
                
                if !Network.checkForAuth(data: data) {
                    completion(StatusCode(code: 0, message: "Auth requested!"), nil)
                    return
                }
                
            if let decodedData = try? JSONDecoder().decode([GroupModel].self, from: data) {
                completion(StatusCode(code: response.response?.statusCode ?? 0), decodedData)
            }else {
                completion(StatusCode(NSError(domain: "Cannot parse data", code: 0)), nil)
            }
        }
    }
    
    func joinGroup(token: String, completion: @escaping (StatusCode, GroupModel?) -> ()) {
        let api = Api.joinGroup
        let authToken = AuthApp.shared.token ?? ""
        
        struct JoinToken: Encodable {
            let token: String
        }
        let body = JoinToken(token: token)
        
        let headers: HTTPHeaders = [
            .authorization(bearerToken: authToken)
        ]
        
        AF.request(api.path, method: api.method, parameters: body, headers: headers)
            .response { response in
                guard response.error == nil, let data = response.data else {
                    completion(StatusCode(response.error), nil)
                    return
                }
                if !Network.checkForAuth(data: data) {
                    completion(StatusCode(code: 0, message: "Auth requested!"), nil)
                    return
                }
                if let decodedData = try? JSONDecoder().decode([GroupModel].self, from: data) {
                    completion(StatusCode(code: response.response?.statusCode ?? 0), decodedData.first)
                }else {
                    completion(StatusCode(NSError(domain: "Cannot parse data", code: 0)), nil)
                }
                
            }
    }
    
    func generateInviteLink(groupId: String, completion: @escaping (StatusCode, String?) -> ()) {
        let api = Api.generateInvitation(id: groupId)
        let authToken = AuthApp.shared.token ?? ""
        
        let headers: HTTPHeaders = [
            .authorization(bearerToken: authToken)
        ]
        
        struct ResponseModel: Decodable {
            let token: String
        }
        
        AF.request(api.path, method: api.method, headers: headers)
            .response { response in
                guard response.error == nil, let data = response.data else {
                    completion(StatusCode(response.error), nil)
                    return
                }
                if !Network.checkForAuth(data: data) {
                    completion(StatusCode(code: 0, message: "Auth requested!"), nil)
                    return
                }
                if let decodedData = try? JSONDecoder().decode(ResponseModel.self, from: data) {
                    completion(StatusCode(code: response.response?.statusCode ?? 0), decodedData.token)
                }else {
                    completion(StatusCode(NSError(domain: "Cannot parse data", code: 0)), nil)
                }
            }
    }
}
