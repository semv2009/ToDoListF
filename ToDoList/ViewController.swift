//
//  ViewController.swift
//  ToDoList
//
//  Created by developer on 11.03.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        var task :Task = Task(name: "firsd", descriptionTask: "go to univrity", date: NSDate(), importance: Importance.Necessary)
        print(task)
        task.descriptionTask = "i wanna to fly"
        print(task)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

