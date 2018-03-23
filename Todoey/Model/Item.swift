//
//  Item.swift
//  Todoey
//
//  Created by Jesse Olson on 23/3/18.
//  Copyright © 2018 Jesse Olson. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    
    //MARK: - Properties
    @objc dynamic var title: String = ""
    
    @objc dynamic var done : Bool = false
    
    @objc dynamic var timeCreated : Date?
    
    //-------------------------------------------------------------------------------------//
    
    //MARK: - Relationships
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
