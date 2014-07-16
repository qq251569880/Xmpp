//
//  ChatNavigationController.swift
//  Xmpp
//
//  Created by 张宏台 on 14-7-14.
//  Copyright (c) 2014年 张宏台. All rights reserved.
//

import UIKit
struct Message{
    var content:String
    var sender:String
}

class MassageViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var messages = Message[]()
    @IBOutlet var MessageTextField : UITextField
    @IBOutlet var sendBtn : UIButton
    var chatWithUser = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //acountBtn.addTarget(self, action: "acountBtnClicked:", forControlEvents: .TouchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title:"关闭", style: .Plain, target:self, action:"closeBtnClicked")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func closeBtnClicked(){
        self.navigationController.popToRootViewControllerAnimated(true)
    }
    //UITableViewDataSource协议实现
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) ->UITableViewCell{
        var identifier:String = "msgCell"
        var cell : UITableViewCell? = tableView?.dequeueReusableCellWithIdentifier(identifier) as? UITableViewCell
        if cell {
            cell = UITableViewCell(style:.Default,reuseIdentifier:identifier)
        }
        
        var message = messages[indexPath.row]
        cell!.textLabel.text = message.content
        cell!.detailTextLabel.text = message.sender
        return cell!
    }
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int{
        return messages.count
    }
    //UITableViewDelegate协议实现

}
