//
//  ViewController.swift
//  Pizza Reverse
//
//  Created by Simon Ng on 5/6/2017.
//  Code written by Jayven Nhan
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import Intents

class ViewController: UIViewController {
    
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var ButtonChart: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        INPreferences.requestSiriAuthorization { (status) in
            
        }
        
        if BankAccount.checkBalance()!.isZero {
            BankAccount.setBalance(toAmount: 1000)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func checkBalance() {
        guard let balance = BankAccount.checkBalance() else { return }
        balanceLabel.text = "Account Balance: $\(balance)"
    }
    
    @IBAction func showChart(_ sender: Any) {
        
        //let vcClass = PieChartViewController.self as UIViewController.Type
        //let vc = vcClass.init()
        //self.navigationController?.pushViewController(vc, animated: true)
        let myViewController = PieChartViewController(nibName: "PieChartViewController", bundle: nil)
        self.present(myViewController, animated: true, completion: nil)
    
    }
    
    
}
