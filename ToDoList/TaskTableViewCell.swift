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
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var stikerView: UIView!
    
    @IBOutlet weak var hourLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    func updateUI(){
        nameLabel.text = task?.name
        descriptionLabel.text = task?.descriptionTask
        
        let colorStiker:UIColor
        switch task!.importance{
        case .Necessary: colorStiker = UIColor.blueColor()
        case .NotNecessary: colorStiker = UIColor.greenColor()
        case .Urgently: colorStiker = UIColor.redColor()
        case .Usually: colorStiker = UIColor.grayColor()
        }
        stikerView.backgroundColor = colorStiker
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        let hour = dateFormatter.stringFromDate((task?.date)!)
        dateFormatter.dateFormat = "dd MMM"
        let date = dateFormatter.stringFromDate((task?.date)!)
        hourLabel.text = hour
        dateLabel.text = date
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
