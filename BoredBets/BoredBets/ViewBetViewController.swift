//
//  ViewBetViewController.swift
//  BoredBets
//
//  Created by Markus Notti on 10/23/16.
//  Copyright © 2016 SauceKitchen. All rights reserved.
//

import UIKit

class ViewBetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    var bet:Bet!
    var comments: [(String, String)] = []

    @IBOutlet weak var betTypeLabel: UILabel!
    @IBOutlet weak var betTitleLabel: UILabel!
    @IBOutlet weak var potLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        Bet.betsRef().child(bet.id).observe(.value, with: { snapshot in
            let title = snapshot.childSnapshot(forPath: "title").value as! String
            let pot = snapshot.childSnapshot(forPath: "pot").value as! Int
            
            //updating fields on view
            self.betTitleLabel.text = title
            self.potLabel.text = String(pot)
            
            //updating bet member variables
            self.bet.title = title
        })
        self.reloadTable()
        self.betTitleLabel.text = self.bet?.title
        self.betTypeLabel.text = self.bet?.type
        
        self.commentField.delegate = self;
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        self.bet.attachComment(commentField.text!) {self.reloadTable()}
        commentField.text = ""
        return false
    }
    
    //TABLE VIEW STUFF
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)
        cell.textLabel?.text = comments[indexPath.row].0
        cell.detailTextLabel?.text = comments[indexPath.row].1
        return cell
    }
    
    func reloadTable()
    {
        self.bet.getComments(){(comments: [(String, String)]) in
            self.comments = comments
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
        }
    }
    
    //END TABLE VIEW STUFF

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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "viewBetToMakeWager") {
            let mwvc = segue.destination as! MakeWagerViewController
            mwvc.bet = self.bet
            
        }
    }
    
    @IBAction func saveWagerViewController(segue:UIStoryboardSegue) {
    }
    
    @IBAction func saveChangesViewController(segue:UIStoryboardSegue) {
    }

}
