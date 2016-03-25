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
    
    var orderMark: Int{
        switch self.mark{
            case true: return 1
            case false: return 0
        }
    }
    
    var orderImportance: Int{
        if let importance = self.importance{
            switch importance{
            case .Low: return 2
            case .Normal: return 1
            case .Hight: return 0
            }
        }else{
            return 4
        }
    }
    required convenience init(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObjectForKey(TaskKey.Name) as! String
        let date = aDecoder.decodeObjectForKey(TaskKey.Date) as? NSDate
        let importance = ((aDecoder.decodeObjectForKey(TaskKey.Importance ) as? String) != nil) ? Importance(rawValue: ((aDecoder.decodeObjectForKey( "importance" ) as! String))) :nil
        let mark = aDecoder.decodeObjectForKey(TaskKey.Mark) as! Bool
        self.init(name: name,date: date,importance: importance,mark:mark)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.name, forKey: TaskKey.Name)
        aCoder.encodeObject(self.date, forKey: TaskKey.Date)
        aCoder.encodeObject((self.importance != nil) ? self.importance!.rawValue: nil, forKey: TaskKey.Importance)
        aCoder.encodeObject(self.mark, forKey: TaskKey.Mark)
    }
    
    struct TaskKey{
        static let Name = "name"
        static let Date = "date"
        static let Importance = "importance"
        static let Mark = "mark"
    }
    
}

public enum Importance: String{
    case Low = "Low"
    case Normal = "Normal"
    case Hight = "Hight"
    
    var order: Int{
        switch self{
            case .Low: return 2
            case .Normal: return 1
            case .Hight: return 0
        }
    }
    static let orderNil:Int = 4
    
    static let allValue = [Low.rawValue,Normal.rawValue,Hight.rawValue]
}

