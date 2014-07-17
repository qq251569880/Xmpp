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

class MassageViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,MessageDelegate {
    
    var messages = Message[]()
    @IBOutlet var MessageTextField : UITextField
    @IBOutlet var sendBtn : UIButton
    var chatWithUser = String()
    @IBOutlet var tView : UITableView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //acountBtn.addTarget(self, action: "acountBtnClicked:", forControlEvents: .TouchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title:"关闭", style: .Plain, target:self, action:"closeBtnClicked")
        var del:AppDelegate  = self.appDelegate();
        del.messageDelegate = self
        sendBtn.addTarget(self, action: "sendButton:", forControlEvents: .TouchUpInside)
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
    func tableView(tableView:UITableView ,cellForRowAtIndexPath indexPath:NSIndexPath ) ->UITableViewCell{
    
        var identifier:String = "msgCell";
    
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier(identifier) as UITableViewCell
    
        if (cell == nil) {
            cell = UITableViewCell(style:.Subtitle ,reuseIdentifier:identifier)
        }
    
        var msg:Message = messages[indexPath.row];
    
        cell.textLabel.text = msg.content;
        cell.detailTextLabel.text = msg.sender
        cell.accessoryType = .None;
    
        return cell;
    
    }
    //取得当前程序的委托
    func  appDelegate() -> AppDelegate{
        
        return UIApplication.sharedApplication().delegate as AppDelegate;
        
    }
    
    //取得当前的XMPPStream
    func xmppStream() -> XMPPStream{
        
        return self.appDelegate().xmppStream!;
    }
    //KKMessageDelegate
    func newMessageReceived(var msg:Message){
    
        messages.append(msg)
    
        self.tView.reloadData()
    
    }
    func sendButton(sender:UIButton) {
        
        //本地输入框中的信息
        var message:String = self.MessageTextField.text
/*
        if (message != "") {
            
            //XMPPFramework主要是通过KissXML来生成XML文件
            //生成<body>文档
            var body:NSXMLElement = NSXMLElement.elementWithName("body")
            body.setStringValue(message)
            
            //生成XML消息文档
            var mes:NSXMLElement = NSXMLElement.elementWithName("message")
            //消息类型
            mes.addAttributeWithName("type",stringValue:"chat")
            //发送给谁
            mes.addAttributeWithName("to" ,stringValue:chatWithUser)
            //由谁发送
            mes.addAttributeWithName("from" ,stringValue:NSUserDefaults.standardUserDefaults().stringForKey(USERID) as NSString)
            //组合
            mes.addChild(body)
            
            //发送消息
            self.xmppStream().sendElement(mes)
            
            self.MessageTextField.text = ""
            self.MessageTextField.resignFirstResponder()
            
            var msg:Message = Message(content:message,sender:"you")
            
            
            messages.append(msg)
            
            //重新刷新tableView
            self.tView.reloadData()
            
        }
        
*/
    }
}
