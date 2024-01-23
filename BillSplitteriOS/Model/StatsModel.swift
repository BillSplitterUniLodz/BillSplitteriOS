//
//  StatsModel.swift
//  BillSplitteriOS
//
//  Created by Temur on 23/01/2024.
//

import Foundation
struct StatsModel: Decodable {
    let balance: [Owner]
    let users: [Participant]
}

struct Owner: Decodable {
    let username: String
    let payers: [Payer]
}

struct Payer: Decodable {
    let username: String
    let amount: Int
}
