//
//  SetBetDetailsViewController.swift
//  BoredBets
//
//  Created by Markus Notti on 10/29/16.
//  Copyright © 2016 SauceKitchen. All rights reserved.
//

import UIKit

class SetBetDetailsViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "setLocation"){
            let vc = segue.destination as! CreateBetViewController
            vc.betTitle = self.titleTextField.text
        }
    }
 

}
