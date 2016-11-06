//
//  SetBetDetailsViewController.swift
//  BoredBets
//
//  Created by Markus Notti on 10/29/16.
//  Copyright © 2016 SauceKitchen. All rights reserved.
//

import UIKit

class SetBetDetailsViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var betTypePicker: UIPickerView!
    var betTypePickerData: [String] = [String]()
    var betTypes: [String] = [String]()
    var selectedBetType: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleTextField.delegate = self;
        self.betTypes = BetFactory.supportedBetTypes()
        self.selectedBetType = self.betTypes[0]
        for type in self.betTypes{
            self.betTypePickerData.append(BetFactory.betTypeUserDisplay(type: type)!)
        }
        // Do any additional setup after loading the view.
    }

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "setLocation"){
            let vc = segue.destination as! CreateBetViewController
            vc.betTitle = self.titleTextField.text
            vc.betType = self.selectedBetType
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return false to ignore.
    {
        self.view.endEditing(true)
        return false
    }

}
