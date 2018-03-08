//
//  CategoryViewController.swift
//  ToDoey
//
//  Created by Coumba Winfield on 2/25/18.
//  Copyright © 2018 Favor it LLC. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

	let realm = try! Realm()
	
	var categories: Results<Category>?
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		loadCategories()
		
		tableView.separatorStyle = .none
		
		
		tableView.rowHeight = 80
    }

	//MARK: - Tableview Datasource Methods
	// Load data from context
	//set up data source, display everything in persisitent container
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return categories?.count ?? 1
	}
	
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = super.tableView(tableView, cellForRowAt: indexPath)
		
		cell.backgroundColor = UIColor(hexString: (categories?[indexPath.row].bgColor) ?? "1D9BF6")
		
		cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
		guard let categoryColor = UIColor(hexString: (categories?[indexPath.row].bgColor)!) else {fatalError()}
		cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
		
		return cell
	}
	
	//MARK: - TableView Delegate Methods
	//What happens when we click on the category
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: "goToItems", sender: self)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let destinationVC = segue.destination as! TodoListViewController
		
		if let indexPath = tableView.indexPathForSelectedRow {
			destinationVC.selectedCategory = categories?[indexPath.row]
		}
	}
	
	//MARK: - Data Manipulation Methods
	
	func save(category: Category){
		
		do{
			try realm.write {
				realm.add(category)
			}
		} catch {
			print("Error saving context \(error)")
		}
		
		self.tableView.reloadData()
	}
	
	func loadCategories(){
		
		categories = realm.objects(Category.self)

		tableView.reloadData()
	}
	
	//MARK: - Delete Data from Swipe
	
	override func updateModel(at indexPath: IndexPath){
		if let categoryForDeletion = self.categories?[indexPath.row] {
			do{
				try self.realm.write {
					self.realm.delete(categoryForDeletion)
//					action.fulfill(with: .delete)
				}
			} catch {
				print("Error deleting Category \(error)")
			}
		}
	}
	
	//MARK: - Add New Categories
	//to make button  to add new buttons
	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		
		var textField = UITextField()
		
		let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
		
		let action = UIAlertAction(title: "Add", style: .default) { (action) in
			print("Success")
			
			let newCategory = Category()
			newCategory.name = textField.text!
			newCategory.bgColor = UIColor.randomFlat.hexValue()

			
			self.save(category: newCategory)
			
		}
		
		alert.addTextField { (alertTextField) in
			alertTextField.placeholder = "Create New Category"
			textField = alertTextField
		}
		
		alert.addAction(action)
		present(alert, animated: true, completion: nil)
		
	}
	
	
	
	
}
