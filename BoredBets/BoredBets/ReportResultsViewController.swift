//
//  ReportResultsViewController.swift
//  BoredBets
//
//  Created by Richard Guzikowski on 11/21/16.
//  Copyright © 2016 SauceKitchen. All rights reserved.
//

import UIKit

class ReportResultsViewController: UIViewController {
    var mediatorId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func reportResults(_ sender: AnyObject) {
        User.usersRef().child(self.mediatorId).child("numberComplaints").observeSingleEvent(of: .value, with: { snapshot in
            var value = snapshot.value as! Int
            value += 1
            User.usersRef().child(self.mediatorId).child("numberComplaints").setValue(value)
        })
        
        navigationController?.popViewController(animated: true)
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
