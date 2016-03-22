//
//  Task.swift
//  ToDoList
//
//  Created by developer on 11.03.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
class Task:NSObject,NSCoding{
    
    var name: String{
        willSet{
            if newValue.characters.count > 0{
                self.name = newValue
            }
        }
    }
    
    var descriptionTask: String{
        willSet{
            if newValue.characters.count > 0{
                self.descriptionTask = newValue
            }
        }
    }
    
    var date: NSDate
    
    var importance: Importance
    
    override var description: String{
        return "Name:\(self.name) Description:\(descriptionTask) Date:\(date.description) Importance:\(importance)"
    }
    
    
    
    init(name:String,descriptionTask:String,date:NSDate,importance:Importance){
        self.name = name
        self.descriptionTask = descriptionTask
        self.date = date
        self.importance = importance
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObjectForKey("name") as! String
        let descriptionTask = aDecoder.decodeObjectForKey("descriptionTask") as! String
        let date = aDecoder.decodeObjectForKey("date") as! NSDate
        let importance = Importance(rawValue: (aDecoder.decodeObjectForKey( "importance" ) as! String)) ?? .Usually
        self.init(name: name,descriptionTask: descriptionTask,date: date,importance: importance)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeObject(self.descriptionTask, forKey: "descriptionTask")
        aCoder.encodeObject(self.date, forKey: "date")
        aCoder.encodeObject(self.importance.rawValue, forKey: "importance")
    }
}
public enum Importance: String{
    case Urgently = "Urgently"
    case NotNecessary = "NotNecessary"
    case Necessary = "Necessary"
    case Usually = "Usually"
    static let allValue = [Urgently.rawValue,NotNecessary.rawValue,Necessary.rawValue,Usually.rawValue]}



//public struct Importance {
//    static let Urgently: String = "Urgently"
//    static let NotNecessary: String = "NotNecessary"
//    static let Necessary: String = "Necessary"
//}
