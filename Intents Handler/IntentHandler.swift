//
//  IntentHandler.swift
//  Intents Handler
//
//  Created by Simon Ng on 5/6/2017.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import Intents


class IntentHandler: INExtension, INSendPaymentIntentHandling, INRequestPaymentIntentHandling, INPayBillIntentHandling {
    
    func handle(intent: INSendPaymentIntent, completion: @escaping (INSendPaymentIntentResponse) -> Void) {
        print("Hacer un pago:", intent)
        guard let amount = intent.currencyAmount?.amount?.doubleValue else {
            completion(INSendPaymentIntentResponse(code: .failure, userActivity: nil))
            return
        }
        
        if ((BankAccount.checkBalance()?.isLess(than: amount))!)
        {
            completion(INSendPaymentIntentResponse(code: .failureInsufficientFunds, userActivity: nil))
        }
        else
        {
            BankAccount.withdraw(amount: amount)
            completion(INSendPaymentIntentResponse(code: .success, userActivity: nil))
        }
    }
    
    func confirm(intent: INSendPaymentIntent, completion: @escaping (INSendPaymentIntentResponse) -> Void) {
        print("confirmar:", intent)
        
        let response = INSendPaymentIntentResponse(code: .ready, userActivity: nil)
        response.paymentRecord = INPaymentRecord(payee: intent.payee, payer: nil, currencyAmount: intent.currencyAmount, paymentMethod: nil, note: intent.note, status: .pending)
        
        completion(response)
    }
    
    
    func handle(intent: INRequestPaymentIntent, completion: @escaping (INRequestPaymentIntentResponse) -> Void) {
        
        guard let amount = intent.currencyAmount?.amount?.doubleValue else {
            completion(INRequestPaymentIntentResponse(code: .failure, userActivity: nil))
            return
        }
        BankAccount.deposit(amount: amount)
        completion(INRequestPaymentIntentResponse(code: .success, userActivity: nil))
    }
    
    func handle(intent: INPayBillIntent, completion: @escaping (INPayBillIntentResponse) -> Void) {
        print("Pagar Factura:", intent)
        
        guard let amount = intent.transactionAmount?.amount?.amount?.doubleValue else {
            print("Fallo:", intent)
            completion(INPayBillIntentResponse(code: .failure, userActivity: nil))
            return
        }
        BankAccount.withdraw(amount: amount)
        print("Todo bien:", intent)
        completion(INPayBillIntentResponse(code: .success, userActivity: nil))
    }
}
