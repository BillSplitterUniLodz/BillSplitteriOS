//
//  TransactionModel.swift
//  BillSplitteriOS
//
//  Created by Temur on 01/01/2024.
//

import Foundation
struct ExpenseModel: Codable {
    let amount: Double
    let payer_uuids: [String]
    let name: String
    let group_uuid: String
    let user_uuid: String
    let expense_uuid: String
    let created_at: String
    let updated_at: String
    let amount_display: String
}
