//
//  ChatViewController.swift
//  Xmpp
//
//  Created by 张宏台 on 14-7-14.
//  Copyright (c) 2014年 张宏台. All rights reserved.
//


import UIKit

let USERID:String = "userId"
let PASS:String = "Pass"
let SERVER:String = "Server"

class LoginTableViewController: UITableViewController,UITextFieldDelegate {

    @IBOutlet var userText : UITextField
    @IBOutlet var passwdText : UITextField
    @IBOutlet var serverText : UITextField

    var chat : ChatViewController = ChatViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //acountBtn.addTarget(self, action: "acountBtnClicked:", forControlEvents: .TouchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title:"返回", style: .Plain, target:self, action:"closeClicked")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title:"登录", style: .Plain, target:self, action:"loginClicked")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func closeClicked(){
        self.dismissModalViewControllerAnimated(true)
    }
    func loginClicked(){
        var err = validText(userText.text, pass: passwdText.text, server: serverText.text)
        if err == 0 {
            
            var defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(userText.text,forKey:USERID)
            defaults.setObject(passwdText.text,forKey:PASS)
            defaults.setObject(serverText.text,forKey:SERVER)
            defaults.synchronize()
            self.dismissModalViewControllerAnimated(true)
            
            chat.view.frame = self.view.bounds
            self.navigationController.pushViewController(chat,animated:true)
        }
    }
    func validText(usr:NSString,pass:NSString,server:NSString) -> Int{
        var alert:UIAlertView = UIAlertView()
        alert.title = "提示"
        
        var ret = 0
        if usr.length > 0 {
            if pass.length > 0 {
                if server.length > 0{
                    return ret
                }
                else{
                    ret = 3
                    alert.message = "请输入服务器地址"
                    serverText.becomeFirstResponder()
                }
            }
            else{
                ret = 2
                alert.message = "请输入密码"
                passwdText.becomeFirstResponder()
            }
        }
        else{
            ret = 1
            alert.message = "请输入用户名"
            userText.becomeFirstResponder()
        }
        alert.addButtonWithTitle("OK")
        alert.show()
        return ret
    }
    func textFieldShouldReturn(textField:UITextField) -> Bool {
        if (textField == self.userText) {
            textField.resignFirstResponder();
        }
        if (textField == self.passwdText) {
            textField.resignFirstResponder();
        }
        if (textField == self.serverText) {
            textField.resignFirstResponder();
        }
        return true
    }
}
