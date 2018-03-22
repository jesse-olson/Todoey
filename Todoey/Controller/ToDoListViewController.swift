//
//  ViewController.swift
//  Todoey
//
//  Created by Jesse Olson on 21/3/18.
//  Copyright © 2018 Jesse Olson. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemList = [Item]()

    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
        print(dataFilePath)
        // Do any additional setup after loading the view, typically from a nib.
        
//        if let items = defaults.array(forKey: "ToDoListArray") as? [String] {
//            itemList = items
//        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: TableView Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        
        let item = itemList[indexPath.row]
        
        cell.textLabel?.text = item.name
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }
    
    //MARK: TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemList[indexPath.row])
        
        itemList[indexPath.row].done = !itemList[indexPath.row].done
        
        saveItems()
        
        tableView.reloadData()
        //Will show the selected row as selected for a second then deselect it.
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    

    //MARK: Add new Item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            //What will happen once the user clicks the add button on our UIAlert
            var newItem = Item()
            
            newItem.name = textField.text!
            
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
    
    func saveItems(){
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(itemList)
            try data.write(to: dataFilePath!)
        }
        catch{
            print("Error encoding the array, \(error)")
        }
    }
    
    func loadItems(){
        
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                itemList = try decoder.decode([Item].self, from: data)
            }
            catch{
                print("ERROR")
            }
        }
    }
    

}

