//
//  TaskTableViewCell.swift
//  ToDoList
//
//  Created by developer on 11.03.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    var task: Task?{
        didSet{
            updateUI()
        }
    }
    
    var mark:Bool = false{
        didSet{
            task?.mark = mark
            if mark {
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: (task?.name)!)
                attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
                nameLabel.attributedText = attributeString
            }else{
                nameLabel.text = task?.name
            }
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var stikerView: UIView!
    
    @IBOutlet weak var hourLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    func updateUI(){
        mark = (task?.mark)!
        
        let colorStiker:UIColor
        if let importance = task!.importance{
            switch importance{
            case .Low: colorStiker = UIColor.blueColor()
            case .Normal: colorStiker = UIColor.greenColor()
            case .Hight: colorStiker = UIColor.redColor()
            }
        }else{
            colorStiker = UIColor.grayColor()
        }
        stikerView.backgroundColor = colorStiker
        
        if let date = task?.date{
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "hh:mm"
            let hour = dateFormatter.stringFromDate(date)
            dateFormatter.dateFormat = "dd MMM"
            let date = dateFormatter.stringFromDate(date)
            hourLabel.text = hour
            dateLabel.text = date
        }else{
            hourLabel.text = ""
            dateLabel.text = ""
        }
    }
    
}
