//
//  LoginViewController.swift
//  BoredBets
//
//  Created by Sam Sobell on 10/25/16.
//  Copyright © 2016 SauceKitchen. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var emailOutlet: UITextField!
    @IBOutlet weak var passwordOutlet: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func storeCurrentUserId(user_id : String){
        UserDefaults.standard.set(user_id, forKey: "user_id")
    }
    
    func showMessagePrompt(_ message: String, title: String = "Oops!"){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        
        self.present(alertController, animated: true, completion: nil)
    }

    @IBAction func createAccountAction(_ sender: AnyObject)
    {
        if self.emailOutlet.text == "" || self.passwordOutlet.text == ""
        {
            self.showMessagePrompt("Please enter an email and password.")
        }
        else
        {
            FIRAuth.auth()?.createUser(withEmail: self.emailOutlet.text!, password: self.passwordOutlet.text!) { (user, error) in
                
                if error == nil {
                    self.storeCurrentUserId(user_id: (user?.uid)!)
                    self.performSegue(withIdentifier: "login", sender: nil)
                }
                else
                {
                    self.showMessagePrompt(error!.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func loginAction(_ sender: AnyObject)
    {
        if self.emailOutlet.text == "" || self.passwordOutlet.text == ""
        {
            self.showMessagePrompt("Please enter an email and password.")
        }
        else
        {
            FIRAuth.auth()?.signIn(withEmail: self.emailOutlet.text!, password: self.passwordOutlet.text!) { (user, error) in
                
                if error == nil {
                    self.storeCurrentUserId(user_id: (user?.uid)!)
                    self.performSegue(withIdentifier: "login", sender: nil)
                }
                else
                {
                    self.showMessagePrompt(error!.localizedDescription)
                }
            }
        }
    }
}
