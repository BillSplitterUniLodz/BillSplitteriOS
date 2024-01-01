//
//  API.swift
//  BillSplitteriOS
//
//  Created by Temur on 01/01/2024.
//

import Foundation

struct Base {
    static let BASE_URL = "https://"
}

public enum HTTPMethod: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case delete = "DELETE"
}

enum Api {
    
    case login
    
    //MARK: - METHOD
    var method: String {
        switch self {
        case .login:
            return HTTPMethod.post.rawValue
        default:
            return HTTPMethod.get.rawValue
        }
    }
    
    //MARK: - PATH
    var path:String {
        
        get {
            var baseURL:String {return Base.BASE_URL}
            switch self {
            default:
                return baseURL
            }
        }
        
        set {
            
        }
    }
}
