//
//  Item.swift
//  ToDoey
//
//  Created by Coumba Winfield on 2/27/18.
//  Copyright © 2018 Favor it LLC. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
	@objc dynamic var title : String = ""
	@objc dynamic var done : Bool = false
	@objc dynamic var dateCreated: Date?
	var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
