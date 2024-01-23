//
//  Expenses+Network.swift
//  BillSplitteriOS
//
//  Created by Temur on 23/01/2024.
//

import Foundation
import Alamofire
extension Network {
    func createTransaction(for group: String, name: String, amount: Int, completion: @escaping (StatusCode, ExpenseModel?) -> ()) {
        let api = Api.createExpense(groupId: group)
        let authToken = AuthApp.shared.token ?? ""
        let headers: HTTPHeaders = [
            .authorization(bearerToken: authToken)
        ]
        
        struct Model: Encodable {
            let expense: Expense
        }
        
        let amountNegative = amount * -1
        
        struct Expense: Encodable {
            let name: String
            let amount: Int
        }
        
        let body = Model(expense: Expense(name: name, amount: amountNegative))
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
                if let decodedData = try? JSONDecoder().decode(ExpenseModel.self, from: data) {
                    completion(StatusCode(code: response.response?.statusCode ?? 0), decodedData)
                }else {
                    completion(StatusCode(NSError(domain: "Cannot parse data", code: 0)), nil)
                }
            }
    }
    
    func getExpenses(for group: String, completion: @escaping (StatusCode, [ExpenseModel]?) -> ()) {
        let api = Api.getExpenses(groupId: group)
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
                if let decodedData = try? JSONDecoder().decode(GroupExpenses.self, from: data) {
                    completion(StatusCode(code: response.response?.statusCode ?? 0), decodedData.expenses)
                }else {
                    completion(StatusCode(NSError(domain: "Cannot parse data", code: 0)), nil)
                }
            }
        
    }
    
    func calculate(groupId: String, completion: @escaping (StatusCode, StatsModel?) -> ()) {
        let api = Api.getGeneralStats(groupId: groupId)
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
                if let decodedData = try? JSONDecoder().decode(StatsModel.self, from: data) {
                    completion(StatusCode(code: response.response?.statusCode ?? 0), decodedData)
                }else {
                    completion(StatusCode(NSError(domain: "Cannot parse data", code: 0)), nil)
                }
            }
    }
}
