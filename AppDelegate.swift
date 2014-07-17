//
//  AppDelegate.swift
//  Xmpp
//
//  Created by 张宏台 on 14-7-13.
//  Copyright (c) 2014年 张宏台. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?
    var xmppStream:XMPPStream?
    var password:String = ""
    var isOpen:Bool = false
    var chatDelegate:ChatDelegate?
    var messageDelegate:MessageDelegate?
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func setupStream(){
    
        //初始化XMPPStream
        xmppStream = XMPPStream()
        xmppStream!.addDelegate(self,delegateQueue:dispatch_get_current_queue());
    
    }
    
    func goOnline(){
    
        //发送在线状态
        var presence:XMPPPresence = XMPPPresence()
        xmppStream!.sendElement(presence)
    
    }
    
    func goOffline(){
    
        //发送下线状态
        var presence:XMPPPresence = XMPPPresence(type:"unavailable");
        xmppStream!.sendElement(presence)
    
    }
    
    func connect() -> Bool{
    
        self.setupStream()
    
        //从本地取得用户名，密码和服务器地址
        var defaults:NSUserDefaults  = NSUserDefaults.standardUserDefaults()
        
        var userId:String  = defaults.stringForKey(USERID)
        var pass:String = defaults.stringForKey(PASS)
        var server:String = defaults.stringForKey(SERVER)
        
        if (!xmppStream!.isDisconnected()) {
            return true
        }
        
        if (userId == "" || pass == "") {
            return false;
        }
        
        //设置用户
        xmppStream!.myJID = XMPPJID.jidWithString(userId);
        //设置服务器
        xmppStream!.hostName = server;
        //密码
        password = pass;
        
        //连接服务器
        var error:NSError? ;
        if (!xmppStream!.connectWithTimeout(10,error: &error)) {
            println("cant connect \(server)")
            return false;
        }
    
        return true;
    
    }
    
    func disconnect(){
    
        self.goOffline()
        xmppStream!.disconnect()
    
    }
    //XMPPStreamDelegate协议实现
    //连接服务器
    func xmppStreamDidConnect(sender:XMPPStream ){
    
        isOpen = true;
        var error:NSError? ;
        //验证密码
        xmppStream!.authenticateWithPassword(password ,error:&error);
    
    }
    
    //验证通过
    func xmppStreamDidAuthenticate(sender:XMPPStream ){
    
        self.goOnline()
    }
    
    //收到消息
    func xmppStream(sender:XMPPStream ,didReceiveMessage message:XMPPMessage ){
    
        //    NSLog(@"message = %@", message);
        
        var cont:String = message.elementForName("body").stringValue();
        var from:String = message.attributeForName("from").stringValue();
        
        var msg:Message = Message(content:cont,sender:from)

        
        //消息委托(这个后面讲)
        messageDelegate?.newMessageReceived(msg);
    
    }
    
    //收到好友状态
    func xmppStream(sender:XMPPStream ,didReceivePresence presence:XMPPPresence ){
    
        //    NSLog(@"presence = %@", presence);
        
        //取得好友状态
        var presenceType:NSString = presence.type() //online/offline
        //当前用户
        var userId:NSString  = sender.myJID.user;
        //在线用户
        var presenceFromUser:NSString  = presence.from().user;
        
        if (!presenceFromUser.isEqualToString(userId)) {
            
            //在线状态
            var srv:String = "nqc1338a"
            if (presenceType.isEqualToString("available")) {
                
                //用户列表委托(后面讲)
                chatDelegate?.newBuddyOnline("\(presenceFromUser)@\(srv)")
                
            }else if (presenceType.isEqualToString("unavailable")) {
                //用户列表委托(后面讲)
                chatDelegate?.buddyWentOffline("\(presenceFromUser)@\(srv)")
            }
            
        }
    
    }

}






