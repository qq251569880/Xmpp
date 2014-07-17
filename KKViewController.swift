//
//  ViewController.swift
//  Xmpp
//
//  Created by 张宏台 on 14-7-13.
//  Copyright (c) 2014年 张宏台. All rights reserved.
//

import UIKit
let USERID:NSString = "userId"
let PASS:NSString = "Pass"
let SERVER:NSString = "Server"
class KKViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,ChatDelegate {
    
    var onlineUsers = String[]()
    var chatUserName:String = ""
    @IBOutlet var tView : UITableView

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tView.delegate = self
        tView.dataSource = self
        //设定在线用户委托
        var del:AppDelegate = self.appDelegate();
        del.chatDelegate = self;
    }
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        
        var defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var ologin : AnyObject! = defaults.objectForKey(USERID)
        
        

        if (ologin != nil) {
            var login:NSString = ologin as NSString
            if (self.appDelegate().connect()) {
                println("show buddy list")
                
                newBuddyOnline("myself")
            }
            
        }else {
            var alert:UIAlertView  = UIAlertView()
            alert.title = "提示"
            alert.message = "您还没有设置账号"
            alert.delegate = self
            alert.addButtonWithTitle("设置")
            alert.show()
            //设定用户
            self.Account(self)
            
        }

    }
    func alertView(var alertView:UIAlertView , clickedButtonAtIndex buttonIndex:Int){
    
        if (buttonIndex == 0) {
            self.Account(self)
        
        }
    
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func Account(sender : AnyObject) {
        self.performSegueWithIdentifier("login",sender:self)
    }

    //UITableViewDataSource协议实现
    func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath: NSIndexPath?) ->UITableViewCell{
        let identifier:String = "userCell"
        var cell : UITableViewCell? = tableView?.dequeueReusableCellWithIdentifier(identifier) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style:.Default,reuseIdentifier:identifier)
        }else
        {
            println("cell is nil")
        }
        cell!.textLabel.text = onlineUsers[indexPath!.row]
        return cell!
    }
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int{
        return onlineUsers.count
    }
    //UITableViewDelegate协议实现
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!){
        //start a Chat
        chatUserName = onlineUsers[indexPath.row];
        
        self.performSegueWithIdentifier("chat",sender:self)
        
    }
    func prepareForSegue(segue:UIStoryboardSegue ){
        
        if (segue.identifier == "chat") {
            var chatController:ChatViewController  = segue.destinationViewController as ChatViewController;
            chatController.chatWithUser = chatUserName;
            println("Now chatting with \(chatUserName)")
        }
    }
    //取得当前程序的委托
    func  appDelegate() -> AppDelegate{
    
        return UIApplication.sharedApplication().delegate as AppDelegate
    
    }
    
/*    //取得当前的XMPPStream
    func xmppStream() -> XMPPStream{
    
        return self.appDelegate().xmppStream!
    }

*/
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
            self.tView!.reloadData();
        }

    }
    func buddyWentOffline(buddyName:String){
        var i = 0
        for user in onlineUsers{
            if (user == buddyName) {
                onlineUsers.removeAtIndex(i)
                self.tView!.reloadData();
                break
            }
            i++
        }

    }
    func didDisconnect()
    {
    }


}







