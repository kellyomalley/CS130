//
//  MakeWagerViewController.swift
//  BoredBets
//
//  Created by Markus Notti on 10/23/16.
//  Copyright © 2016 SauceKitchen. All rights reserved.
//

import UIKit

class MakeWagerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var userBetPickerView: UIPickerView!

    @IBOutlet weak var coinsLeftMessage: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    
    @IBOutlet weak var userBetTextField: UITextField!
    
    @IBOutlet weak var rangeLabel: UILabel!
    
    var bet:Bet!
    var coinsLeft: Int!
    var outcomes: [String] = []
    var pickerIsActive = false
    var userBet: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        User.usersRef().child(User.currentUser()).observe(.value, with: { snapshot in
            if let coin = snapshot.childSnapshot(forPath: "coins").value as? Int {
                self.coinsLeft = coin
            }
            else {
                self.coinsLeft = 0
            }
            self.coinsLeftMessage.text = "You Have " + String(self.coinsLeft) + " coins"
            self.coinsLeftMessage.textAlignment = .center
        })
        self.handleBetTypeRelatedSetup()
        self.hideKeyboardWhenTapped()
        
    }
    
    //sets up the view according to the type of bet
    func handleBetTypeRelatedSetup(){
        switch self.bet.type!{
            case "YesNoBet":
                self.userBetPickerView.isHidden = false
                self.pickerIsActive = true
                self.outcomes.append(self.bet.outcome1)
                self.outcomes.append(self.bet.outcome2)
                self.userBet = self.outcomes[0]
            case "ExactNumericalBet":
                self.userBetTextField.isHidden = false
                self.rangeLabel.isHidden = false
                self.rangeLabel.text = "Range for this bet is \(self.bet.outcome1!) to \(self.bet.outcome2!)"
            default:
                print("BET TYPE NOT SUPPORTED IN MAKE WAGER CONTROLLER")
        }
    }

    
    @IBAction func userBetEditingChanged(_ sender: Any) {
        self.userBet = self.userBetTextField.text!
    }

    
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func makeWagerDidTouch(_ sender: AnyObject) {
        //retrieve current user:
        let user_id = User.currentUser()
        //make new wager object and attach it to bet
        let betAmount = Int(self.amountTextField.text!)
        if(checkInput() != "valid"){
            BBUtilities.showMessagePrompt(checkInput(), controller: self)
        }
        else if (betAmount! > self.coinsLeft!) {
            BBUtilities.showMessagePrompt("You don't have enough coins!", controller: self)
        }
        else if (betAmount! <= 0) {
            BBUtilities.showMessagePrompt("Please enter a positive number", controller: self)
        }
        else {
            let newCoinAmount = self.coinsLeft! - betAmount!
            User.usersRef().child(User.currentUser()).child("coins").setValue(newCoinAmount)
            self.bet.attachWager(userId: user_id, betAmount: betAmount!, userBet: self.userBet)
        }
        
    }
    
    func checkInput() -> String{
        if (self.amountTextField.text == ""){
            return "Must enter a valid amount to bet"
        }
        else if (Int(self.amountTextField.text!) == nil){
            return "Must enter a valid integer amount to bet"
        }
        else if(self.userBet == ""){
            return "You must put a value for your predicted outcome field"
        }
        else{
            switch self.bet.type!{
            case "YesNoBet":
                return "valid"
            case "ExactNumericalBet":
                let minGuess = Int(self.bet.outcome1)!
                let maxGuess = Int(self.bet.outcome2)!
                if (self.userBetTextField.text == ""){
                    return "You must put a value in the predicted outcome field"
                }
                
                let userGuess = Int(self.userBetTextField.text!)
                if (userGuess == nil){
                    return "Your guess must be a valid integer!"
                }
                else if(userGuess! < minGuess || userGuess! > maxGuess){
                    return "Your guess must be within the range specified for this bet"
                }
                else{
                    return "valid"
                }
            default:
                print("BET TYPE NOT SUPPORTED IN MAKE WAGER CONTROLLER")
            }
        }
        return "valid"
    }
    
    //PICKER FUNCTIONS
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (self.pickerIsActive){
            return outcomes.count
        }
        else{
            return 0
        }
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return outcomes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        self.userBet = outcomes[row]
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
}
