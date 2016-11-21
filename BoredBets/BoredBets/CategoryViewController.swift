//
//  CategoryViewController.swift
//  BoredBets
//
//  Created by Sam Sobell on 11/20/16.
//  Copyright © 2016 SauceKitchen. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var categoryTable: UITableView!
    var selectedCategory : String!
    var categories: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.categoryTable.register(UITableViewCell.self, forCellReuseIdentifier: "globalBetCell")
        Categories.getCategories {
            self.categories = $0
            self.categoryTable.reloadData()
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count // your number of cell here
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "globalBetCell", for: indexPath)
        cell.textLabel?.text = self.categories[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedCategory = self.categories[indexPath.row]
        performSegue(withIdentifier: "categoryToBetList", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! BetsInCategoryViewController
        vc.selectedCategory = self.selectedCategory
    }
}
