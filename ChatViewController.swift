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
    var ctime:String
}

class ChatViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,MessageDelegate {
    
    var messages = Message[]()
    @IBOutlet var MessageTextField : UITextField
    @IBOutlet var sendBtn : UIButton
    var chatWithUser = String()
    @IBOutlet var tView : UITableView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //acountBtn.addTarget(self, action: "acountBtnClicked:", forControlEvents: .TouchUpInside)
        tView.delegate = self
        tView.dataSource = self
        
        var del:AppDelegate  = self.appDelegate();
        del.messageDelegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backClicked(sender : UIBarButtonItem) {
            self.dismissViewControllerAnimated(true,completion:nil)
    }

/*    //UITableViewDataSource协议实现
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) ->UITableViewCell{
        var identifier:String = "msgCell"
        var cell : UITableViewCell? = tableView?.dequeueReusableCellWithIdentifier(identifier) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style:.Subtitle,reuseIdentifier:identifier)
        }
        
        var message = messages[indexPath.row]
        println("display msg:(\(message.content),\(message.sender))")

        cell!.textLabel.text = message.content
        cell!.detailTextLabel.text = message.sender
        return cell!
    }*/
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int{
        return messages.count
    }
    //UITableViewDelegate协议实现
    func tableView(tableView:UITableView! ,cellForRowAtIndexPath indexPath:NSIndexPath ) ->UITableViewCell{
        let padding:CGFloat = 10.0
        var identifier:String = "msgCell";
    
        var cell:MessageCell? = tableView?.dequeueReusableCellWithIdentifier(identifier) as? MessageCell
    
        if (cell == nil) {
            cell = MessageCell(newStyle:.Subtitle ,newReuseIdentifier:identifier)
        }
    
        var msg:Message = messages[indexPath.row];
        
        var textSize = CGSize(width: 260.0 ,height: 10000.0)

        var font:UIFont  = UIFont.systemFontOfSize(18)
        var rect:CGRect = msg.content.boundingRectWithSize(textSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:font], context: nil)
        rect.size.width += (padding/2)
        
        
        cell!.messageContentView.text = msg.content;
        cell!.accessoryType = .None;
        cell!.userInteractionEnabled = false;
        
        var bgImage:UIImage?
        
        //发送消息
        if (msg.sender == "you") {
            //背景图
            bgImage = UIImage(named:"BlueBubble2")
            bgImage = bgImage!.stretchableImageWithLeftCapWidth(20,topCapHeight:15)
            cell!.messageContentView.frame = CGRectMake(rect.origin.x+padding, rect.origin.y+padding*4, rect.size.width, rect.size.height)
            
            cell!.bgImageView.frame = CGRectMake(cell!.messageContentView.frame.origin.x - padding/2, cell!.messageContentView.frame.origin.y - padding/2 , rect.size.width + padding, rect.size.height + padding)
        }else {
            
            bgImage = UIImage(named:"GreenBubble2").stretchableImageWithLeftCapWidth(14, topCapHeight:15)
            
            cell!.messageContentView.frame = CGRectMake(320-rect.size.width - padding-rect.origin.x, padding*4+rect.origin.y, rect.size.width, rect.size.height)
            cell!.bgImageView.frame = CGRectMake(cell!.messageContentView.frame.origin.x - padding/2, cell!.messageContentView.frame.origin.y - padding/2, rect.size.width + padding, rect.size.height + padding)
        }
        
        cell!.bgImageView.image = bgImage;
        cell!.senderAndTimeLabel.text = "\(msg.sender) \(msg.ctime)"
        
    
        return cell!;
    
    }
    //每一行的高度
    func tableView(tableView:UITableView, heightForRowAtIndexPath indexPath:NSIndexPath) -> CGFloat{
        let padding:CGFloat = 20.0
        var msg:Message = messages[indexPath.row];
        
        var textSize = CGSize(width: 260.0 ,height: 10000.0)
        var font:UIFont  = UIFont.systemFontOfSize(18)
        var rect:CGRect = msg.content.boundingRectWithSize(textSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:font], context: nil)
        //var size = msg.content.sizeWithAttributes([NSFontAttributeName:font])
        rect.size.height += padding*2
    
        var height:CGFloat = rect.size.height < 65 ? 65 : rect.size.height;
    
        return height;
    
    }
    //取得当前程序的委托
    func  appDelegate() -> AppDelegate{
        
        return UIApplication.sharedApplication().delegate as AppDelegate;
        
    }
    
    //取得当前的XMPPStream
/*    func xmppStream() -> XMPPStream{
        
        return self.appDelegate().xmppStream!;
    }*/
    //KKMessageDelegate
    func newMessageReceived(var msg:Message){
    
        messages.append(msg)
    
        self.tView.reloadData()
    
    }
    @IBAction func sendButton(sender : UIButton) {
        
        //本地输入框中的信息
        var message:String = self.MessageTextField.text

        if (message != "") {
            
            //XMPPFramework主要是通过KissXML来生成XML文件
            //生成<body>文档
            var body:DDXMLElement = DDXMLElement.elementWithName("body") as DDXMLElement
            body.setStringValue(message)
            
            //生成XML消息文档
            var mes:DDXMLElement = DDXMLElement.elementWithName("message") as DDXMLElement
            //消息类型
            mes.addAttributeWithName("type",stringValue:"chat")
            //发送给谁
            mes.addAttributeWithName("to" ,stringValue:chatWithUser)
            println("send to \(chatWithUser)")
            //由谁发送
            mes.addAttributeWithName("from" ,stringValue:NSUserDefaults.standardUserDefaults().stringForKey(USERID) as NSString)
            //组合
            mes.addChild(body)
            
            //发送消息
            self.appDelegate().sendElement(mes)
            
            self.MessageTextField.text = ""
            self.MessageTextField.resignFirstResponder()
            
            var msg:Message = Message(content:message,sender:"you",ctime:getCurrentTime())
            
            messages.append(msg)
            println("send msg:\(messages.count)(\(msg.content),\(msg.sender))")

            //重新刷新tableView
            self.tView.reloadData()
        }
    }

}
