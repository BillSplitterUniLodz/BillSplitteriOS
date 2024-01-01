//
//  Groups+Network.swift
//  BillSplitteriOS
//
//  Created by Temur on 01/01/2024.
//

import Foundation
extension Network {
    func createGroup(name: String, completion: @escaping (StatusCode, GroupModel?) -> ()) {
        
        //Api
        let api:Api = Api.login
        
        //Body
        let parameters = [
            [
                "key": "name",
                "value": name,
                "type": "text"
            ]] as [[String : String]]
        
        
        //Header
        let boundary = generateBoundaryString()
        let body = generateMutableData(boundary: boundary, parameters: parameters, imagesData: []) as Data
        
        push(api: api, body: body, headers: nil, type: GroupModel.self) { result in
            switch result {
            case .success(let model):
                completion(StatusCode(code: 0), model)
            case .failure(let error):
                completion(error, nil)
            }
        }
    }
}
