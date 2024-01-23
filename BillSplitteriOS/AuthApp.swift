//
//  AuthApp.swift
//  BillSplitteriOS
//
//  Created by Temur on 01/01/2024.
//

import Foundation
class AuthApp {
    static let shared: AuthApp = AuthApp()
    
    private var keyToken:String { "tokenKey" }
    private var keyAuth:String { "MyAutorizationKey"}
    private let keyFirstEnter: String = "firstEnter"
    private let defaults = UserDefaults.standard
    //MARK: Token
    var token:String? {
        get {
            guard let token = defaults.string(forKey: keyToken) else {return nil}
            return token
        }
        set {
            guard let token = newValue else {return removeToken()}
            // remove old entry
            removeToken()
            //save new data
            defaults.setValue(token, forKey: keyToken)
        }
    }
    
    
    //MARK: login end password
    var autorization: UserData? {
        get {
            guard let object = defaults.object(forKey: keyAuth) else {return nil}
            guard let data = object as? Data else {return nil}
            guard let object = try? JSONDecoder().decode(UserData.self, from: data) else {return nil}
            return object
        }
        set {
            guard let newValue = newValue else {
                removeAutorization()
                removeToken()
                return
            }
            // remove old entry
            removeAutorization()
            //save new data
            guard let data = try? JSONEncoder().encode(newValue) else {return}
            UserDefaults.standard.setValue(data, forKey: keyAuth)
            
        }
    }
    
    //MARK: - Token Action
    func removeToken() {
        defaults.removeObject(forKey: keyToken)
    }
    
    
    private func removeAutorization() {
        defaults.removeObject(forKey: keyAuth)
    }
    
    //MARK: - Language
    var language: String {
        get {
            return UserDefaults.standard.string(forKey: "LanguageTypeKey") ?? "en"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "LanguageTypeKey")
            UserDefaults.standard.synchronize()
        }
    }
    
    //MARK: - First Enter to App
    var isFirstEnter: Int {
        get {
            return UserDefaults.standard.integer(forKey: keyFirstEnter)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: keyFirstEnter)
            UserDefaults.standard.synchronize()
        }
    }
}
