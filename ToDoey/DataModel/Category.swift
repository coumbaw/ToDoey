//
//  Category.swift
//  ToDoey
//
//  Created by Coumba Winfield on 2/27/18.
//  Copyright © 2018 Favor it LLC. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
	@objc dynamic var name : String = ""
	let items = List<Item>()
	
}
