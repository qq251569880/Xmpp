//
//  MessageCell.swift
//  Xmpp
//
//  Created by 张宏台 on 14-7-17.
//  Copyright (c) 2014年 张宏台. All rights reserved.
//

import Foundation
import UIKit

func getCurrentTime() -> String{
    
    var nowUTC:NSDate  = NSDate.date()
    
    var dateFormatter:NSDateFormatter  = NSDateFormatter()
    dateFormatter.timeZone = NSTimeZone.localTimeZone()
    dateFormatter.dateStyle = .MediumStyle
    dateFormatter.timeStyle = .MediumStyle
    
    return dateFormatter.stringFromDate(nowUTC)
    
}

class MessageCell:UITableViewCell {

    var senderAndTimeLabel:UILabel
    var messageContentView:UITextView
    var bgImageView:UIImageView
    
    init(newStyle:UITableViewCellStyle, newReuseIdentifier:NSString) {
        
        senderAndTimeLabel = UILabel( frame:CGRectMake(10, 10, 300, 20))
        bgImageView = UIImageView(frame:CGRectZero)
        messageContentView = UITextView()
        
        super.init(style:newStyle, reuseIdentifier:newReuseIdentifier)
        //日期标签
        //居中显示
        senderAndTimeLabel.textAlignment = .Center
        senderAndTimeLabel.font = UIFont.systemFontOfSize(12.0)
        //文字颜色
        senderAndTimeLabel.textColor = UIColor.lightGrayColor()
        contentView.addSubview(senderAndTimeLabel)
        
        //背景图
        contentView.addSubview(bgImageView)
        
        //聊天信息
        messageContentView.backgroundColor = UIColor.clearColor()
        //不可编辑
        messageContentView.editable = false;
        messageContentView.scrollEnabled = false;
        messageContentView.sizeToFit()
        contentView.addSubview(messageContentView)
        

    
    }

}