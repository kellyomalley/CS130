//
//  SettleBetViewController.swift
//  BoredBets
//
//  Created by Markus Notti on 11/6/16.
//  Copyright © 2016 SauceKitchen. All rights reserved.
//

import UIKit

class SettleBetViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    var bet: Bet!
    var outcomes: [String]!
    var finalBetOutcome: String = ""
    var pickerActive: Bool = false
    
    @IBOutlet weak var outcomeTextField: UITextField!
    @IBOutlet weak var outcomePickerView: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController!.navigationBar.topItem!.title = "Cancel"
        self.handleBetType()

        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTapped()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleBetType(){
        switch self.bet.type{
            case "YesNoBet":
                self.outcomePickerView.isHidden = false
                self.outcomes = [bet.outcome1, bet.outcome2]
                self.pickerActive = true
                self.finalBetOutcome = self.outcomes[0]
            case "ExactNumericalBet":
                self.outcomeTextField.isHidden = false
            default:
                print("ERROR, NOT YET IMPLEMENTED BET TYPE")
        }
    }
    
    @IBAction func didUpdateOutcomeField(_ sender: Any) {
        finalBetOutcome = outcomeTextField.text!
    }
    @IBAction func concludeBetDidTouch(_ sender: Any) {
        //actually settle the bet
        if (checkInput() != "valid"){
            BBUtilities.showMessagePrompt(checkInput(), controller: self)
        }
        else{
            self.finalBetOutcome = self.outcomeTextField.text!
            self.bet.finalOutcome = self.finalBetOutcome
            Bet.betsRef().child(self.bet.id).child("finalOutcome").setValue(self.finalBetOutcome)
            self.bet.settleBet(bet: bet, completion: {
                //after bet has been settled, make transition to results page
                let baseViewController = self.navigationController?.viewControllers[0]
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let nextvc = storyboard.instantiateViewController(withIdentifier: "betResultsView") as! BetResultsViewController
                nextvc.bet = self.bet
                self.navigationController?.setViewControllers([baseViewController!, nextvc], animated: true)
                //self.performSegue(withIdentifier: "settleBetToBetResults", sender: self)
            })
            
            //determine where to navigate to
            /*guard let controllers = navigationController?.viewControllers else { return }
            let count = controllers.count
            if count > 2 {
                if let mvc = controllers[count - 2] as? MediatorViewController {
                    navigationController?.popToViewController(mvc, animated: true)
                }
            }*/
        }
    }
    
    func checkInput() -> String{
        switch self.bet.type{
        case "YesNoBet":
            return "valid"
        case "ExactNumericalBet":
            if (self.finalBetOutcome == ""){
                return "Must enter a final bet outcome"
            }
            let betOutcomeNum = Int(self.finalBetOutcome)
            let minOutcome = Int(self.bet.outcome1)!
            let maxOutcome = Int(self.bet.outcome2)!
            if(betOutcomeNum == nil){
                return "Must enter a valid integer"
            }
            else if(betOutcomeNum! < minOutcome || betOutcomeNum! > maxOutcome){
                return "Final outcome must fall within bet range: \(minOutcome) to \(maxOutcome)"
            }
            else{
                return "valid"
            }
        default:
            print("ERROR, NOT YET IMPLEMENTED BET TYPE")
            return "Invalid bet type"
        }
    }
    //PICKER FUNCTIONS
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerActive){
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
        finalBetOutcome = outcomes[row]
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "settleBetToBetResults"){
            let nextvc = segue.destination as! BetResultsViewController
            nextvc.bet = self.bet
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
