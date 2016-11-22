//
//  SetBetDetailsViewController.swift
//  BoredBets
//
//  Created by Markus Notti on 10/29/16.
//  Copyright © 2016 SauceKitchen. All rights reserved.
//

import UIKit



class SetBetDetailsViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var betTitleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var betTypePicker: UIPickerView!

    var betTypePickerData: [String] = [String]()
    var betTypes: [String] = [String]()
    var selectedBetType: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup hidden textlabels
        
        self.descriptionTextView.delegate = self
        self.descriptionTextView.textColor = UIColor.gray
        self.titleTextField.delegate = self;
        
        self.betTypes = BetFactory.supportedBetTypes()
        self.selectedBetType = self.betTypes[0]
        for type in self.betTypes{
            self.betTypePickerData.append(BetFactory.betTypeUserDisplay(type: type)!)
        }
        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTapped()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (self.betTitleLabel.isHidden == true){
            self.betTitleLabel.center.y += 25
            self.betTitleLabel.isHidden = false
            UIView.animate(withDuration: 0.5, animations: {
                self.betTitleLabel.center.y -= 25
            })

        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.text?.isEmpty)! {
            self.betTitleLabel.center.y += 25
            self.betTitleLabel.isHidden = true
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.gray {
            textView.text = nil
            textView.textColor = UIColor.black
            self.descriptionLabel.isHidden = false
            UIView.animate(withDuration: 0.5, animations: {
                self.descriptionLabel.center.y -= 25
            })
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Optional Description"
            textView.textColor = UIColor.gray
            self.descriptionLabel.center.y += 25
            self.descriptionLabel.isHidden = true
        }
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        self.navigationItem.setHidesBackButton(true, animated:true)
////        self.navigationController?.setNavigationBarHidden(true, animated: true)
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationItem.setHidesBackButton(false, animated:true)
////        self.navigationController?.setNavigationBarHidden(false, animated: true)
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //PICKER FUNCTIONS
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return self.betTypePickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.betTypePickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedBetType = self.betTypes[row]
    }
    
    @IBAction func continueDidTouch(_ sender: Any) {
        if(self.titleTextField.text == ""){
            BBUtilities.showMessagePrompt("Please enter a title for your bet!", controller: self)
        }
        else{
            self.performSegue(withIdentifier: "toSelectCategory", sender: self)
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toSelectCategory"){
            let vc = segue.destination as! SelectCategoryViewController
            let bet = BetFactory.sharedFactory.makeBet(type: self.selectedBetType)
            bet?.title = self.titleTextField.text
            bet?.state = BetState.Active
            vc.bet = bet
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return false to ignore.
    {
        self.view.endEditing(true)
        return false
    }

}
