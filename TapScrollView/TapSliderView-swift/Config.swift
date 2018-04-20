
//
//  Config.swift
//  TapScrollView
//
//  Created by mac on 2018/4/20.
//  Copyright © 2018年 Joker. All rights reserved.
//

import Foundation
import UIKit

let Title_Font = UIFont.systemFont(ofSize: 13.0)
let Small_TitleFont = UIFont.systemFont(ofSize: 13.0)
let kScreenWidth : CGFloat = UIScreen.main.bounds.size.width
let kScreenHeight : CGFloat = UIScreen.main.bounds.size.height
let Base_Color2 =  RGB(R: 239, G: 240, B: 241,A: 1) //背景灰色
let Base_Color3  = RGB(R: 214, G: 215, B: 216, A: 1)  //下一步不可选中灰色
let Base_Orange  = RGB(R: 237,G: 120,B: 14,A: 1)   //主题橙色
let Color_Black  =  RGB(R: 51,G: 51,B: 51,A: 1) //字体黑色
let Color_Gray =  RGB(R: 128,G: 128,B: 128,A: 1)  //字体灰色
let Color_Hilighted =  RGB(R: 206, G: 104, B: 10, A: 1)//点击后的颜色
let Title_Color1 =  RGB(R: 165, G: 190, B: 68,A: 1) //字体青色
let view_width = (kScreenWidth-20-10)/3


func RGB(R:CGFloat,G:CGFloat,B:CGFloat,A:CGFloat)->UIColor{
    
    return UIColor.init(red: R/255.0, green: G/255.0, blue: B/255.0, alpha: A)
}
