//
//  IntentHandler.swift
//  Intents Handler
//
//  Created by Simon Ng on 5/6/2017.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import Intents


class IntentHandler: INExtension, INStartWorkoutIntentHandling, INEndWorkoutIntentHandling, INSendPaymentIntentHandling, INRequestPaymentIntentHandling {
    
    func handle(intent: INStartWorkoutIntent, completion: @escaping (INStartWorkoutIntentResponse) -> Void) {
     
        print("Start Workout Intent:", intent)
        
        let userActivity: NSUserActivity? = nil
        guard let spokenPhrase = intent.workoutName?.spokenPhrase else {
            completion(INStartWorkoutIntentResponse(code: .failureNoMatchingWorkout, userActivity: userActivity))
            return
        }
        
        completion(INStartWorkoutIntentResponse(code: .continueInApp, userActivity: userActivity))
    }
    
    func handle(intent: INEndWorkoutIntent, completion: @escaping (INEndWorkoutIntentResponse) -> Void) {
        
    }
    
    func handle(intent: INSendPaymentIntent, completion: @escaping (INSendPaymentIntentResponse) -> Void) {
        print("Hacer un pago:", intent)
        guard let amount = intent.currencyAmount?.amount?.doubleValue else {
            completion(INSendPaymentIntentResponse(code: .failure, userActivity: nil))
            return
        }
        BankAccount.withdraw(amount: amount)
        completion(INSendPaymentIntentResponse(code: .success, userActivity: nil))
    }
    
    
    func handle(intent: INRequestPaymentIntent, completion: @escaping (INRequestPaymentIntentResponse) -> Void) {
        
        guard let amount = intent.currencyAmount?.amount?.doubleValue else {
            completion(INRequestPaymentIntentResponse(code: .failure, userActivity: nil))
            return
        }
        BankAccount.deposit(amount: amount)
        completion(INRequestPaymentIntentResponse(code: .success, userActivity: nil))
    }
}

