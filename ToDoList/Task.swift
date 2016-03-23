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
    
    var date: NSDate?
    
    var importance: Importance?
    
    override var description: String{
        return "Name:\(self.name) "
    }
    
    var mark:Bool
    
    init(name:String,date:NSDate?,importance:Importance?,mark:Bool){
        self.name = name
        self.date = date
        self.importance = importance
        self.mark = mark
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObjectForKey("name") as! String
        let date = aDecoder.decodeObjectForKey("date") as? NSDate
        let importance = ((aDecoder.decodeObjectForKey( "importance" ) as? String) != nil) ? Importance(rawValue: ((aDecoder.decodeObjectForKey( "importance" ) as! String))) :nil
        let mark = aDecoder.decodeObjectForKey("mark") as! Bool
        self.init(name: name,date: date,importance: importance,mark:mark)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeObject(self.date, forKey: "date")
        aCoder.encodeObject((self.importance != nil) ? self.importance!.rawValue: nil, forKey: "importance")
        aCoder.encodeObject(self.mark, forKey: "mark")
    }
}
public enum Importance: String{
    case Low = "Low"
    case Normal = "Normal"
    case Hight = "Hight"
    static let allValue = [Low.rawValue,Normal.rawValue,Hight.rawValue]
}



//public struct Importance {
//    static let Urgently: String = "Urgently"
//    static let NotNecessary: String = "NotNecessary"
//    static let Necessary: String = "Necessary"
//}
