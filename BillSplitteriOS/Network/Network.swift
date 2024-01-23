//
//  Network.swift
//  BillSplitteriOS
//
//  Created by Temur on 01/01/2024.
//

import Foundation
import Alamofire
class Network {
    static let shared = Network()
    private init() {}

    func decodeData<T: Decodable>(response: AFDataResponse<Data>,data: Data, completion: @escaping (StatusCode, T?) -> ()) {
        if let decodedData = try? JSONDecoder().decode(T.self, from: data) {
            completion(StatusCode(code: response.response?.statusCode ?? 0), decodedData)
        }else {
            completion(StatusCode(true), nil)
        }
    }
    
    static func checkForAuth(data: Data) -> Bool {
        if "unauthorized" == String(data: data, encoding: .utf8) {
            AuthApp.shared.token = nil
            return false
        }else {
            return true
        }
    }
    
}
