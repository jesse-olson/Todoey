//
//  ViewController.swift
//  Todoey
//
//  Created by Jesse Olson on 21/3/18.
//  Copyright © 2018 Jesse Olson. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    
    //MARK: Global Properties.
    var itemList = [Item]()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    //-----------------------------------------------------------------------------------------------------//
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //-----------------------------------------------------------------------------------------------------//
    
    //MARK: TableView Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        
        let item = itemList[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //Ternary operator. An more concise way of writing a basic if/else statement
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //Used to specify the amount of rows are to be created in the table view.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }
    
    //-----------------------------------------------------------------------------------------------------//
    
    //MARK: TableView Delegate Methods
    
    //What happens when a cell in the table view is selected.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Toggle the Boolean value of Item.done.
        itemList[indexPath.row].done = !itemList[indexPath.row].done
        
        //Save the change.
        saveItems()
        
        //Reload the data being displayed.
        tableView.reloadData()
        
        //Will show the selected row as selected for a second then deselect it.
        tableView.deselectRow(at: indexPath, animated: true)
   
    }
    
    //-----------------------------------------------------------------------------------------------------//
    
    //MARK: Add new Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            //What will happen once the user clicks the add button on our UIAlert
            let newItem = Item(context: self.context)
            
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemList.append(newItem)
            
            self.saveItems()
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    //-----------------------------------------------------------------------------------------------------//
    
    //MARK: Core Data Functions
    
    func saveItems(){
        do{
            try context.save()
        }
        catch{
            print("Error trying to save the context, \(error)")
        }
    }
    
    //Function used to READ data from the Core Database.
    /*
        This function uses a new technique in the form of internal and external parameters.
        with request: NSFetchRequest<Item>
        The with in this case is an external parameter. It is used to make the function traslate better into english.
        ie. load items with the request : NAME OF REQUEST.
        The request: part is the internal parameter and is what will be used to call the parameter within the function.
 
        The other new technique used in this function is setting a default value for the parameter.
        NSFetchRequest<Item> = Item.fetchRequest()
        When no input parameter is given use Item.fetchRequest as the input.
     */
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }
        else{
            request.predicate = categoryPredicate
        }
        
        do{
            itemList = try context.fetch(request)
        }
        catch{
            print("Error trying to fetch the data, \(error)")
        }
        
        tableView.reloadData()
    }
}


//MARK: ---Search Bar Delegate---
extension ToDoListViewController : UISearchBarDelegate{
    
    //What happens when a search is entered into the searchbar and submitted
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //Set up the request.
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        
        loadItems(with: request, predicate: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

