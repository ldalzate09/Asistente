//
//  BankAccount.swift
//  Asistente
//
//  Created by Leydy Alzate on 10/17/18.
//  Copyright © 2018 Leydy Alzate. All rights reserved.
//

import Foundation

class BankAccount {
    
    private init() {}
    static let bankAccountKey = "Bank Account"
    static let suiteName = "group.-25Y77FG78.co.com.bancolombia.eliza"
    
    static func setBalance(toAmount amount: Double) {
        guard let defaults = UserDefaults(suiteName: suiteName) else { return }
        defaults.set(amount, forKey: bankAccountKey)
        defaults.synchronize()
    }
    
    static func checkBalance() -> Double? {
        guard let defaults = UserDefaults(suiteName: suiteName) else { return nil }
        defaults.synchronize()
        let balance = defaults.double(forKey: bankAccountKey)
        return balance
    }
    
    @discardableResult
    static func withdraw(amount: Double) -> Double? {
        guard let defaults = UserDefaults(suiteName: suiteName) else { return nil }
        let balance = defaults.double(forKey: bankAccountKey)
        let newBalance = balance - amount
        setBalance(toAmount: newBalance)
        return newBalance
    }
    
    @discardableResult
    static func deposit(amount: Double) -> Double? {
        guard let defaults = UserDefaults(suiteName: suiteName) else { return nil }
        let balance = defaults.double(forKey: bankAccountKey)
        let newBalance = balance + amount
        setBalance(toAmount: newBalance)
        return newBalance
    }
    
}
