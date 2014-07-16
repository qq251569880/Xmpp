//
//  ViewController.swift
//  Xmpp
//
//  Created by 张宏台 on 14-7-13.
//  Copyright (c) 2014年 张宏台. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,ChatDelegate {
    
    var onlineUsers = String[]()
    var chatUserName:String = ""
    @IBOutlet var tView : UITableView
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title:"账号", style: .Plain, target:self, action:"closeBtnClicked")
        self.tView.delegate = self
        self.tView.dataSource = self
        
        //设定在线用户委托
        var del:AppDelegate = self.appDelegate();
        del.chatDelegate = self;
    }
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        
        var login:NSString = NSUserDefaults.standardUserDefaults().objectForKey("userId") as NSString
        if (login.length != 0) {
            
            if (self.appDelegate().connect()) {
                println("show buddy list")
                
            }
            
        }else {
            
            //设定用户
            self.Account()
            
        }

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
        //start a Chat
        chatUserName = onlineUsers[indexPath.row];
        
        self.performSegueWithIdentifier("chat",sender:self)
        
    }
    func prepareForSegue(segue:UIStoryboardSegue ){
        
        if (segue.identifier == "chat") {
            var msgController:MassageViewController  = segue.destinationViewController as MassageViewController;
            msgController.chatWithUser = chatUserName;
        }
    }
    //取得当前程序的委托
    func  appDelegate() -> AppDelegate{
    
        return UIApplication.sharedApplication().delegate as AppDelegate;
    
    }
    
    //取得当前的XMPPStream
    func xmppStream() -> XMPPStream{
    
        return self.appDelegate().xmppStream;
    }
    

    func newBuddyOnline(buddyName:String){
        var i = 0
        for user in onlineUsers{
            if (user == buddyName) {
                break
            }
            i++
        }
        if i == onlineUsers.count{
            onlineUsers.append(buddyName)
            self.tView.reloadData();
        }

    }
    func buddyWentOffline(buddyName:String){
        var i = 0
        for user in onlineUsers{
            if (user == buddyName) {
                onlineUsers.removeAtIndex(i)
                self.tView.reloadData();
                break
            }
            i++
        }

    }
    func didDisconnect()
    {
    }


}







