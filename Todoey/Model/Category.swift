//
//  Category.swift
//  Todoey
//
//  Created by Jesse Olson on 23/3/18.
//  Copyright © 2018 Jesse Olson. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    //MARK: - Properties
    @objc dynamic var name: String = ""
    
    //-------------------------------------------------------------------------------------//
    
    //MARK: - Relationships
    let items = List<Item>()
    
}
