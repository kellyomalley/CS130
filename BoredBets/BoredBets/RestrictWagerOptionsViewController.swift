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
    
    let outcome1TextFieldTag = 0
    let outcome2TextFieldTag = 1
    let minOutcomeTextFieldTag = 2
    let maxOutcomeTextFieldTag = 3
    var changedLabelPositioning = false
    
    @IBOutlet weak var maxOutcomeLabel: UILabel!
    @IBOutlet weak var minOutcomeLabel: UILabel!
    @IBOutlet weak var outcome2Label: UILabel!
    @IBOutlet weak var outcome1Label: UILabel!

    @IBOutlet weak var exactNumericalBetView: UIView!
    @IBOutlet weak var yesNoBet: UIView!
    
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
        self.outcome1TextField.tag = outcome1TextFieldTag
        self.outcome2TextField.tag = outcome2TextFieldTag
        
        self.minOutcomeTextField.delegate = self
        self.maxOutcomeTextField.delegate = self
        self.minOutcomeTextField.tag = minOutcomeTextFieldTag
        self.maxOutcomeTextField.tag = maxOutcomeTextFieldTag
        
        
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
    
    func anyMissingFields() -> Bool{
        switch self.bet.type!{
        case "YesNoBet":
            if(self.outcome1TextField.text == "" || self.outcome2TextField.text == ""){
                return true
            }
        case "ExactNumericalBet":
            if (self.minOutcomeTextField.text == "" || self.maxOutcomeTextField.text == ""){
                return true
            }
        default:
            print("ERROR: Bet type passed in is not valid")
            
        }
        return false
    }
    
    //if any invalid input, returns a string indicating the type of discretion
    //if valid, returns "valid"
    func inputCheck() -> String{
        switch self.bet.type!{
        case "YesNoBet":
            return "valid"
        case "ExactNumericalBet":
            let minNum = Int(self.minOutcomeTextField.text!)
            let maxNum = Int(self.maxOutcomeTextField.text!)
            if (minNum == nil || maxNum == nil){
                return "Min and max values must contain valid integers"
            }
            else if (minNum! >= maxNum!){
                return "Min outcome field must be less than max outcome field"
            }
        default:
            print("ERROR: Bet type passed in is not valid")
            return "Invalid bet type"
        }
        return "valid"
    }
    
    @IBAction func setLocationDidTouch(_ sender: Any) {
        if (anyMissingFields()){
            BBUtilities.showMessagePrompt("You're missing a required field.", controller: self)
        }
        else if(inputCheck() != "valid"){
            BBUtilities.showMessagePrompt(inputCheck(), controller: self)
        }
        else{
            performSegue(withIdentifier: "setLocation", sender: self)
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
    
    // called when 'return' key pressed. return false to ignore.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (!self.changedLabelPositioning){
            self.minOutcomeLabel.center.y += 25
            self.maxOutcomeLabel.center.y += 25
            self.outcome1Label.center.y += 25
            self.outcome2Label.center.y += 25
            self.changedLabelPositioning = true
        }
            switch (textField.tag){
            case outcome2TextFieldTag:
                animateLabelAppear(label: self.outcome2Label)
            case outcome1TextFieldTag:
                animateLabelAppear(label: self.outcome1Label)
            case minOutcomeTextFieldTag:
                animateLabelAppear(label: self.minOutcomeLabel)
            case maxOutcomeTextFieldTag:
                animateLabelAppear(label: self.maxOutcomeLabel)
            default:
                print("do nothing")
                
        }
    }
    
    func animateLabelAppear(label: UILabel){
        if (label.isHidden == true){
           // label.center.y += 25
            label.isHidden = false
            UIView.animate(withDuration: 0.5,
                           animations:{
                            label.center.y -= 25
            })
        }
    }
    
    func animateLabelDisappear(label: UILabel, textField: UITextField){
        if (textField.text?.isEmpty)! {
            label.center.y += 25
            label.isHidden = true
        }

    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        switch (textField.tag){
            case outcome2TextFieldTag:
                animateLabelDisappear(label: self.outcome2Label, textField: self.outcome2TextField)
            case outcome1TextFieldTag:
                animateLabelDisappear(label: self.outcome1Label,textField: self.outcome1TextField)
            case minOutcomeTextFieldTag:
                animateLabelDisappear(label: self.minOutcomeLabel, textField: self.minOutcomeTextField)
            case maxOutcomeTextFieldTag:
                animateLabelDisappear(label: self.maxOutcomeLabel, textField: self.maxOutcomeTextField)
            default:
                print("do nothing")
            
        }
    }
}
