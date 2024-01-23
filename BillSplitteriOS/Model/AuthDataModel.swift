//
//  AuthDataModel.swift
//  BillSplitteriOS
//
//  Created by Temur on 01/01/2024.
//

import Foundation

struct AuthData: Codable {
    let user: AuthUser
}

struct AuthUser: Codable {
    let username: String
    let email: String
    let password: String
}

struct AuthResponseBody: Decodable {
    let created_at: String
    let updated_at: String
    let user_uuid: String
    let username: String
    let email: String
    let jwt_token: String
}

struct Body: Decodable {
    let token: String
}

//struct AuthToken:Decodable {
//    let success: Bool
//    let message: String?
//    let body: Body?
//    let code: Int
//}
