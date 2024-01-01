//
//  Result.swift
//  BillSplitteriOS
//
//  Created by Temur on 01/01/2024.
//

import Foundation

enum Result<Model> {
    case success(model: Model)
    case failure(error: StatusCode)
}
