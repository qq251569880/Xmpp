//
//  ViewController.swift
//  Xmpp
//
//  Created by 张宏台 on 14-7-13.
//  Copyright (c) 2014年 张宏台. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var onlineUsers = String[]()

    @IBOutlet var tView : UITableView
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title:"账号", style: .Plain, target:self, action:"closeBtnClicked")
        self.tView.delegate = self
        self.tView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func closeBtnClicked(){
        self.navigationController.popToRootViewControllerAnimated(true)
    }
    
    func Account(){
        
    }
    //UITableViewDataSource协议实现
    func tableView(tableView: UITableView?, cellForRowAtIndexPath: NSIndexPath?) ->UITableViewCell{
        var identifier:String = "userCell"
        var cell : UITableViewCell? = tableView?.dequeueReusableCellWithIdentifier(identifier) as? UITableViewCell
        if cell {
            cell = UITableViewCell(style:.Default,reuseIdentifier:identifier)
        }
        return cell!
    }
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    //UITableViewDelegate协议实现
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!){
        
    }
}







