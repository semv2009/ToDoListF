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
        guard let name = aDecoder.decodeObjectForKey(TaskKey.Name) as? String else { fatalError("Attribute name is nil")}
        let date = aDecoder.decodeObjectForKey(TaskKey.Date) as? NSDate
        var importance:Importance? = nil
        if let importanceValue = aDecoder.decodeObjectForKey(TaskKey.Importance ) as? String{
            importance = Importance(rawValue: (importanceValue))
        }
        guard let mark = aDecoder.decodeObjectForKey(TaskKey.Mark) as? Bool else { fatalError("Attribute mark is nil") }
        self.init(name: name, date: date, importance: importance, mark: mark)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.name, forKey: TaskKey.Name)
        aCoder.encodeObject(self.date, forKey: TaskKey.Date)
        if let importance = self.importance {
             aCoder.encodeObject(importance.rawValue, forKey: TaskKey.Importance)
        }
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
    
    static let allValue = [Low.rawValue,Normal.rawValue,Hight.rawValue]
}

