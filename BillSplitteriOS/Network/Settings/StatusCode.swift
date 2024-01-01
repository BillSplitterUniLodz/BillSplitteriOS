//
//  StatusCode.swift
//  BillSplitteriOS
//
//  Created by Temur on 01/01/2024.
//

import Foundation

struct StatusCode:Decodable {
    var code:Int?
    var error:Bool?
    var title:String?
    var message:String?
    
    init(_ error:Bool) {
        self.code = error ? 400 : 200
        self.message = !error ? nil : "Something went wrong"
    }
    
    init(_ error: Error?) {
        self.code = error?._code ?? 1000
        self.title = "An error has occurred"
        self.message = error?.localizedDescription ??  "Please try again" + "\nerror: \(code!)"
    }
    
    init(code:Int, message:String? = nil) {
        self.code = code
        
        if message == nil {
            switch code {
            case 0:
                self.title = nil
                self.message = message
                self.error = false
            case 11:
                self.title = "Failed to log in"
                self.message = "Authorization error. Try again later" + "error: \(code)"
            case 100:
                self.title = "An error has occurred"
                self.message = "No data from the server. Try again a little later" + "\nerror: \(code)"
            case 101:
                self.title = "Access is closed"
                self.message = "Authorization is only available to Customers" + "\nerror: \(code)"
            case 200...299:
                self.message = message ?? "Something went wrong" + " \(code)"
                self.error = false
            case 401:
                self.title = "Authorization error"
                self.message = message ?? "Incorrect login or password"
            case 403:
                self.title = "Authorization error"
                self.message = message ?? "An error occurred during authorization"
            case 404:
                self.title = "Data upload error"
                self.message = message ?? "No data from server"
            case 405:
                self.title = "Ошибка регистрации"
                self.message = message ?? "не удалось завершить регистрацию. Повторите попытку позже"
            case 417:
                self.title = "You are not authorized"
                self.message = message ?? "Authorization required"
            case 500...999:
                self.title = "Error"
                self.message = "We are aware of this problem and are engaged in troubleshooting. Please try again later." + "error: \(code)"
            case 1000...:
                self.title = "An error has occurred"
                self.message = "Please try again" + "\nerror: \(code)"
            default:
                self.title = "An error has occurred"
                self.message = message ?? "Please try again" + "\nerror: \(code)"
            }
        } else {
            self.message = message
        }
    }
}
