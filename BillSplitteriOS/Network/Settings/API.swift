//
//  API.swift
//  BillSplitteriOS
//
//  Created by Temur on 01/01/2024.
//

import Foundation
import Alamofire
struct Base {
    static let BASE_URL = "http://localhost:3000/"
}

enum Api {
    
    case signUp
    case groups
    case createGroup
    case joinGroup
    case signIn
    case generateInvitation(id: String)
    case createExpense(groupId: String)
    case getGeneralStats(groupId: String)
    case getExpenses(groupId: String)
    case deleteGroup(id: String)
    
    //MARK: - METHOD
    var method: HTTPMethod {
        switch self {
        case .signUp, .createGroup, .joinGroup, .signIn, .generateInvitation, .createExpense:
            return .post
        
        case .groups, .getGeneralStats, .getExpenses:
            return .get
        case .deleteGroup:
            return .delete
        }
    }
    
    //MARK: - PATH
    var path:String {
        
        get {
            var baseURL:String {return Base.BASE_URL }
            switch self {
            case .createGroup: return baseURL + "groups"
            case .signUp: return baseURL + "sign_up"
            case .groups: return baseURL + "groups"
            case .joinGroup: return baseURL + "groups/process_invite"
            case .signIn: return baseURL + "signin"
            case let .generateInvitation(id): return baseURL + "groups/\(id)" + "/generate_invite"
            case let .createExpense(groupId): return baseURL + "groups/\(groupId)/expenses/"
            case .getGeneralStats(groupId: let groupId): return baseURL + "groups/\(groupId)/expenses/stats"
            case .getExpenses(groupId: let groupId): return baseURL + "groups/\(groupId)/expenses/"
            case .deleteGroup(id: let id): return baseURL + "groups/\(id)"
            }
        }
    }
}
