//
//  RestrictWagerOptionsViewController.swift
//  BoredBets
//
//  Created by Markus Notti on 11/6/16.
//  Copyright © 2016 SauceKitchen. All rights reserved.
//

import UIKit

class RestrictWagerOptionsViewController: UIViewController, UITextFieldDelegate {

    var bet: Bet!
    
    @IBOutlet weak var exactNumericalBetView: UIStackView!
    @IBOutlet weak var yesNoBet: UIStackView!
    @IBOutlet weak var outcome2TextField: UITextField!
    @IBOutlet weak var outcome1TextField: UITextField!
    
    @IBOutlet weak var maxOutcomeTextField: UITextField!
    @IBOutlet weak var minOutcomeTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.topItem!.title = "Back"
        self.showRelevantViews()
        
        self.outcome1TextField.delegate = self
        self.outcome2TextField.delegate = self
        self.minOutcomeTextField.delegate = self
        self.maxOutcomeTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func showRelevantViews(){
        switch self.bet.type!{
        case "YesNoBet":
            self.yesNoBet.isHidden = false
        case "ExactNumericalBet":
            self.exactNumericalBetView.isHidden = false
        default:
            print("ERROR: Bet type passed in is not valid")
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleOutcomeInput(){
        switch self.bet.type!{
            case "YesNoBet":
                self.bet.outcome1 = self.outcome1TextField.text
                self.bet.outcome2 = self.outcome2TextField.text
            case "ExactNumericalBet":
                self.bet.outcome1 = self.minOutcomeTextField.text
                self.bet.outcome2 = self.maxOutcomeTextField.text
            default:
                print("ERROR: invalid option in handleOutcomeInput")
        }
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "setLocation"){
            self.handleOutcomeInput()
            let vc = segue.destination as! CreateBetViewController
            vc.bet = self.bet
        }
        // Pass the selected object to the new view controller.
    }
 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return false to ignore.
    {
        self.view.endEditing(true)
        return false
    }
}
