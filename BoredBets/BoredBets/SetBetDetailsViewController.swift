//
//  SetBetDetailsViewController.swift
//  BoredBets
//
//  Created by Markus Notti on 10/29/16.
//  Copyright © 2016 SauceKitchen. All rights reserved.
//

import UIKit



class SetBetDetailsViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var betTypePicker: UIPickerView!
    var betTypePickerData: [String] = [String]()
    var categoryPickerData : [String] = []
    var betTypes: [String] = [String]()
    var selectedBetType: String = ""
    var selectedCategory: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController!.navigationBar.topItem!.title = "Cancel"
        self.titleTextField.delegate = self;
        self.betTypePicker.tag = 0
        self.betTypes = BetFactory.supportedBetTypes()
        self.selectedBetType = self.betTypes[0]
        for type in self.betTypes{
            self.betTypePickerData.append(BetFactory.betTypeUserDisplay(type: type)!)
        }
        self.categoryPicker.tag = 1
        Categories.getCategories { (categoriesList) in
            self.categoryPickerData = categoriesList
            self.categoryPickerData.insert("None", at: 0)
            self.categoryPicker.reloadAllComponents()
            debugPrint(self.categoryPickerData)
        }
        // Do any additional setup after loading the view.
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
        if(pickerView.tag == 0){
            return self.betTypePickerData.count
        }
        else{
            debugPrint(self.categoryPickerData.count)
            return self.categoryPickerData.count
        }
        
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag == 0){
            return self.betTypePickerData[row]
        }
        else{
            return self.categoryPickerData[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView.tag == 0){
            self.selectedBetType = self.betTypes[row]
        }
        else{
            self.selectedCategory = self.categoryPickerData[row]
            if(self.selectedCategory == "None")
            {
                self.selectedCategory = ""
            }
        }
    }
    
    @IBAction func continueDidTouch(_ sender: Any) {
        if(self.titleTextField.text == ""){
            BBUtilities.showMessagePrompt("Please enter a title for your bet!", controller: self)
        }
        else{
            self.performSegue(withIdentifier: "restrictWagers", sender: self)
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "restrictWagers"){
            let vc = segue.destination as! RestrictWagerOptionsViewController
            let bet = BetFactory.sharedFactory.makeBet(type: self.selectedBetType)
            bet?.title = self.titleTextField.text
            bet?.state = BetState.Active
            bet?.category = self.selectedCategory
            vc.bet = bet
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return false to ignore.
    {
        self.view.endEditing(true)
        return false
    }

}
