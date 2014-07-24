//
//  ChatViewController.swift
//  Xmpp
//
//  Created by 张宏台 on 14-7-14.
//  Copyright (c) 2014年 张宏台. All rights reserved.
//


import UIKit



class LoginViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet var userText : UITextField

    @IBOutlet var passwdText : UITextField

    @IBOutlet var serverText : UITextField
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //acountBtn.addTarget(self, action: "acountBtnClicked:", forControlEvents: .TouchUpInside)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backClicked(sender : UIBarButtonItem) {
        self.dismissViewControllerAnimated(true,completion:nil)
    }

    @IBAction func loginClicked(sender : UIBarButtonItem) {
        var err = validText(userText.text, pass: passwdText.text, server: serverText.text)
        if err == 0 {
            
            var defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            var user_text:NSString = userText.text
            var pass_text:NSString = passwdText.text
            var server_text:NSString = serverText.text
            defaults.setObject(user_text,forKey:USERID)
            defaults.setObject(pass_text,forKey:PASS)
            defaults.setObject(server_text,forKey:SERVER)
            defaults.synchronize()
            self.dismissViewControllerAnimated(true,completion:nil)
            
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
