//
//  User.swift
//  BillSplitteriOS
//
//  Created by Temur on 01/01/2024.
//

import Foundation
struct Participant: Codable {
    let created_at: String
    let updated_at: String
    let user_uuid: String
    let username: String
    let email: String
}
