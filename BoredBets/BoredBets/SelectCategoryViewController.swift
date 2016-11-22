//
//  SelectCategoryViewController.swift
//  BoredBets
//
//  Created by Markus Notti on 11/21/16.
//  Copyright © 2016 SauceKitchen. All rights reserved.
//

import UIKit

class SelectCategoryViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var categoryPicker: UIPickerView!
    var categoryPickerData : [String] = []
    var selectedCategory: String = ""
    var bet: Bet!

    override func viewDidLoad() {
        super.viewDidLoad()
        Categories.getCategories { (categoriesList) in
            self.categoryPickerData = categoriesList
            self.categoryPickerData.insert("None", at: 0)
            self.categoryPicker.reloadAllComponents()
            debugPrint(self.categoryPickerData)
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
        return self.categoryPickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.categoryPickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedCategory = self.categoryPickerData[row]
        if(self.selectedCategory == "None"){
            self.selectedCategory = ""
        }
    }

    @IBAction func continueDidTouch(_ sender: Any) {
        self.performSegue(withIdentifier: "toOutcomeSpecification", sender: self)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toOutcomeSpecification"){
            let vc = segue.destination as! RestrictWagerOptionsViewController
            bet.category = self.selectedCategory
            vc.bet = bet
        }
    }

}
