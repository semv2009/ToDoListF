//
//  TableViewCellAttemp.swift
//  ToDoList
//
//  Created by developer on 06.04.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit

class TableViewCellAttemp: UITableViewCell {

    @IBOutlet weak var ddasdas: UILabel!
   
    func updateUI(task: Task){
        ddasdas.text = task.name
    }
    
}
