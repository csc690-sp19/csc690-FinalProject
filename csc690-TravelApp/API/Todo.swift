//
//  Todo.swift
//  csc690-TravelApp
//
//  Created by SiuChun Kung on 5/14/19.
//  Copyright © 2019 SiuChun Kung. All rights reserved.
//
import Foundation

class Todo{
    
    var list: [Spot]?     //this is defined array to store the tasks
    
    let userDefault = UserDefaults.standard
    
    
    init(){
        if let test = userDefault.object(forKey: "list") as? [Spot] {
            list = test
        }else{
            list = []
        }
    }
    
    
    func taskSave() {
        userDefault.set(list, forKey: "list")
    }
    
    func taskLoad(){
        list = (userDefault.object(forKey: "list") as? [Spot])
    }
    
}

