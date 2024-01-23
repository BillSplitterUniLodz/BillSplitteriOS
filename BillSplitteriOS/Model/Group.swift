//
//  Group.swift
//  BillSplitteriOS
//
//  Created by Temur on 01/01/2024.
//

import Foundation
struct GroupModel: Decodable {
    let uuid: String
    let name: String
    let created_at: String
    let updated_at: String
    let participants: [Participant]
}
