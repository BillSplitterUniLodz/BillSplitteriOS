//
//  AuthDataModel.swift
//  BillSplitteriOS
//
//  Created by Temur on 01/01/2024.
//

import Foundation

struct AuthData: Codable {
    let username: String
    let email: String
    let password: String
}

struct Body: Decodable {
    let token: String
}

struct AuthToken:Decodable {
    let success: Bool
    let message: String?
    let body: Body?
//    let code: Int
}
