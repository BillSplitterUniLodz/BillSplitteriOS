//
//  TransactionModel.swift
//  BillSplitteriOS
//
//  Created by Temur on 01/01/2024.
//

import Foundation
struct TransactionModel: Codable {
    let id: UUID
    let amount: Double
    let name: String
    let participants: [Participant]
}
