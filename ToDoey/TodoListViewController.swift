//
//  ViewController.swift
//  ToDoey
//
//  Created by Coumba Winfield on 2/20/18.
//  Copyright © 2018 Favor it LLC. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

	var itemArray = ["Find Schmakums", "Make Schmakums", "Eat Schmakums"]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	//MARK - Tableview Datasource Methods
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return itemArray.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
	
		let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
	
		cell.textLabel?.text = itemArray[indexPath.row]
		
		return cell
	}
	
	//MARK - TableView Delegate Methods
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		//print("I was pressed! " + itemArray[indexPath.row])
		
		if 		tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
			tableView.cellForRow(at: indexPath)?.accessoryType = .none
		}
		else {
			tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark

		}

		tableView.deselectRow(at: indexPath, animated: true)
		
			

	}
	
	//MARK - Add New Items

	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		
		var textField = UITextField()
		
		let alert = UIAlertController(title: "Add new Todoey Item", message:"", preferredStyle: .alert)
		
		let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
			//what will happen when user clicks add item button on ui alert
		print("Success")
		self.itemArray.append(textField.text!)
			
		self.tableView.reloadData()

			}
		
		alert.addTextField {(alertTextField) in
			alertTextField.placeholder = "Create new item"
			textField = alertTextField
			
		}
		
		
		
		alert.addAction(action)
		
		present(alert, animated: true, completion: nil)
	}
	
	
	
}

