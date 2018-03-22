//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Jesse Olson on 22/3/18.
//  Copyright © 2018 Jesse Olson. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    //MARK: Global Properties
    
    var categories : [Category] = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add A Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (alert) in
            
            let newCategory = Category(context: self.context)
            
            newCategory.name = textField.text
            
            self.categories.append(newCategory)
            
            self.saveCategories()
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //-----------------------------------------------------------------------------//
    
    //MARK: TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    //-----------------------------------------------------------------------------//
    
    //MARK: TableView Datasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //Returning the amount of categories there are to display.
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
    }
    
    
    //-----------------------------------------------------------------------------//
    
    //MARK: Data Manipulation Methods
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        
        do{
            categories = try context.fetch(request)
        }
        catch{
            print("Error trying to fetch Categories data, \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func saveCategories(){
        
        do{
            try context.save()
        }
        catch{
            print("Error when trying to save category data, \(error)")
        }
        
    }
}