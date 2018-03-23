//
//  AppDelegate.swift
//  Todoey
//
//  Created by Jesse Olson on 21/3/18.
//  Copyright © 2018 Jesse Olson. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    //This gets called when the app is called. Happens first before everything else.
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        do{
            _ = try Realm()
        }
        catch{
            print("Error initialising Realm, \(error)")
        }
    
        return true
    }

}

