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
    
    //MARK: - METHOD
    var method: HTTPMethod {
        switch self {
        case .signUp, .createGroup, .joinGroup, .signIn, .generateInvitation:
            return .post
        default:
            return .get
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
            }
        }
        
        set {
            
        }
    }
}
