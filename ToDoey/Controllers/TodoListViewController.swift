//
//  ViewController.swift
//  ToDoey
//
//  Created by Coumba Winfield on 2/20/18.
//  Copyright © 2018 Favor it LLC. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
	
	@IBOutlet weak var searchBar: UISearchBar!
	let realm = try! Realm()
	
	var todoItems: Results<Item>?
	
	var selectedCategory : Category? {
		didSet{
			loadItems()
		
		}
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
	
		tableView.separatorStyle = .none
		
		}
	

	override func viewWillAppear(_ animated: Bool){
		guard let colorHex = selectedCategory?.bgColor else{fatalError()}
			
			title = selectedCategory?.name
			updateNavBar(withHexCode: colorHex)
	}
		
	override func viewWillDisappear(_ animated: Bool) {
		updateNavBar(withHexCode: "1D9BF6")
	}

	//MARK: - Nav Bar Setup Code Methods
	
	func updateNavBar(withHexCode colorHexCode: String){
		guard let navBar = navigationController?.navigationBar else {fatalError("NAV CONTROLLER DONT EXIST")}

		guard let navBarColor = UIColor(hexString: colorHexCode) else {fatalError()}
		
		navBar.barTintColor = navBarColor
		
		searchBar.barTintColor = navBarColor
		
		navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
		
		navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
		
	}
	
	
	//MARK: - Tableview Datasource Methods
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return todoItems?.count ?? 1
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
	
		let cell = super.tableView(tableView, cellForRowAt: indexPath)
	
		if let item = todoItems?[indexPath.row] {
			
			cell.textLabel?.text = item.title
			
			if let color = UIColor(hexString: selectedCategory!.bgColor)?.darken(byPercentage:(CGFloat(indexPath.row) / CGFloat(todoItems!.count))){
				
				cell.backgroundColor = color
				cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
			}
			
			
			cell.accessoryType = item.done ? .checkmark : .none
			
		} else {
			cell.textLabel?.text = "No items added"
		}

		return cell
	}
	
	//MARK: - TableView Delegate Methods
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		if let item = todoItems?[indexPath.row] {
			do {
				try realm.write {
					item.done = !item.done
				}
			} catch {
				print("Error saving done stat \(error)")
			}
		}

		tableView.reloadData()
		
		tableView.deselectRow(at: indexPath, animated: true)

	}
	
	//MARK: - Add New Items

	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		
		var textField = UITextField()
		
		let alert = UIAlertController(title: "Add new Todoey Item", message:"", preferredStyle: .alert)
		
		let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
			//what will happen when user clicks add item button on ui alert
		print("Success")
		
			if let currentCategory = self.selectedCategory {
				do {
					try self.realm.write{
					let newItem = Item()
					newItem.title = textField.text!
					newItem.dateCreated = Date()
					currentCategory.items.append(newItem)
					}
				} catch {
					print("Error saving new items, \(error)")
				}
			}
			
				self.tableView.reloadData()
		
		}
		alert.addTextField {(alertTextField) in
			alertTextField.placeholder = "Create new item"
			textField = alertTextField
			
		}
		
		
		
		alert.addAction(action)
		
		present(alert, animated: true, completion: nil)
	}
	
	
	//MARK: - Model Manipulation Methods
	
	
		
	func loadItems(){

		todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
		
		 tableView.reloadData()
	}

	//MARK: - Delete Data from Swipe
	
	override func updateModel(at indexPath: IndexPath){
		if let itemForDeletion = todoItems?[indexPath.row] {
			do{
				try realm.write {
					realm.delete(itemForDeletion)
				}
			} catch {
				print("Error deleting Item \(error)")
			}
		}
	}
	

}
 //MARK: - Search Bar Methods
extension TodoListViewController: UISearchBarDelegate {

	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

		todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
	
		tableView.reloadData()
		
	}

	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if searchBar.text?.count == 0 {
			loadItems()

			DispatchQueue.main.async {
				searchBar.resignFirstResponder()

			}

		}
	}
}

