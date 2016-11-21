//
//  GlobalBetViewController.swift
//  BoredBets
//
//  Created by Richard Guzikowski on 11/20/16.
//  Copyright © 2016 SauceKitchen. All rights reserved.
//

import UIKit

class GlobalBetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var categories: [String]!
    var selectedCategory: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "globalBetCell")
        self.categories = BBUtilities.betCategories()
        self.tableView.reloadData()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        return self.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "globalBetCell")! as UITableViewCell
        cell.textLabel?.text = categories[indexPath.row]
        cell.detailTextLabel?.text = categories[indexPath.row]
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedCategory = self.categories[indexPath.row]
        performSegue(withIdentifier: "showSelectedCategory", sender: self)
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showSelectedCategory")
        {
            let sc = segue.destination as! SpecificCategoryBetViewController
            sc.category = self.selectedCategory
        }
    }

    
}
