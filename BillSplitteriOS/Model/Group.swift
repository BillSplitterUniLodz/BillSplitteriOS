//
//  Group.swift
//  BillSplitteriOS
//
//  Created by Temur on 01/01/2024.
//

import Foundation
struct GroupModel: Codable {
    let id: UUID
    let name: String
    let participants: [User]
}
