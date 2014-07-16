//
//  MessageDelegate.swift
//  Xmpp
//
//  Created by 张宏台 on 14-7-16.
//  Copyright (c) 2014年 张宏台. All rights reserved.
//

import Foundation

protocol MessageDelegate{
    func newMessageReceived(msg:Message)
}