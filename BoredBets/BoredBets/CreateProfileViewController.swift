//
//  CreateProfileViewController.swift
//  BoredBets
//
//  Created by Sam Sobell on 11/2/16.
//  Copyright © 2016 SauceKitchen. All rights reserved.
//

import UIKit

class CreateProfileViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func doneEditingButton(_ sender: AnyObject) {
        if self.usernameField.text == ""
        {
            BBUtilities.showMessagePrompt("Please enter a Username", controller: self)
        }
        else
        {
            User.usersRef().child(User.currentUser()).child("username").setValue(self.usernameField.text)
            
            //Give User initial $$$
            User.usersRef().child(User.currentUser()).child("coins").setValue(100)
            User.usersRef().child(User.currentUser()).child("rating").setValue(-1)
            User.usersRef().child(User.currentUser()).child("numberRatings").setValue(0)
            self.performSegue(withIdentifier: "enterAppSegue", sender: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
