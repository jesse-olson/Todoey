//
//  ViewController.swift
//  Todoey
//
//  Created by Jesse Olson on 21/3/18.
//  Copyright © 2018 Jesse Olson. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    
    let realm = try! Realm()
    //MARK: Global Properties.
    var toDoItems: Results<Item>?
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    
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
        
        if let item = toDoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            
            //Ternary operator. An more concise way of writing a basic if/else statement
            cell.accessoryType = item.done ? .checkmark : .none
        }
        else{
            cell.textLabel?.text = "No Items Available"
        }
        
        return cell
    }
    
    //Used to specify the amount of rows are to be created in the table view.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    //-----------------------------------------------------------------------------------------------------//
    
    //MARK: TableView Delegate Methods
    
    //What happens when a cell in the table view is selected.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row]{
            do{
                try realm.write {
                    item.done = !item.done
                }
            }
            catch {
                print("Error when trying to toggle done, \(error)")
            }
        }
        
        //Toggle the Boolean value of Item.done.
        //toDoItems[indexPath.row].done = !toDoItems[indexPath.row].done
        
        //Save the change.
        //saveItems()
        
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
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write {
                        let newItem = Item()
                        
                        newItem.title = textField.text!
                        
                        newItem.timeCreated = Date()
                        
                        currentCategory.items.append(newItem)
                    }
                }
                catch{
                    print("Error item could not be saved, \(error)")
                }
            }

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

    func loadItems(){
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
}


//MARK: ---Search Bar Delegate---
extension ToDoListViewController : UISearchBarDelegate{

    //What happens when a search is entered into the searchbar and submitted
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "timeCreated", ascending: false)
        
        tableView.reloadData()

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

