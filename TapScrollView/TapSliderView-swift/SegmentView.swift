//
//  SegmentView.swift
//  TapScrollView
//
//  Created by mac on 2018/4/20.
//  Copyright © 2018年 Joker. All rights reserved.
//

import UIKit
@objc(SliderLineViewDelegate)
protocol SliderLineViewDelegate {
    func sliderViewAndReloadData(index:NSInteger)
}

class SegmentView: UIView,UIScrollViewDelegate {
    
    weak var delegate : SliderLineViewDelegate?
    
    private var pageScrollView:UIScrollView!
    
    private  var lineScrollView:UIScrollView!
    
    public  var titileColror : UIColor! //字体颜色
    
    public var titleFont:UIFont!//字体大小
    
    public  var sliderViewColor : UIColor!//滑动条的颜色
    
    public  var selectedColor : UIColor!//按钮选中时的颜色
    
    public var buttonWidth: NSInteger! //控件宽度

    private var buttonViewArr :NSMutableArray!
    
    private var lineView:UIView!
    
    private  var currentSelectIndex :NSInteger!//当前选中的按钮下标
    
    private var arrcount:NSInteger!//顶部按钮的数量

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initBaseConfig()
    
    }
    //初始化基本设置
    func initBaseConfig() -> Void {
        
        self.backgroundColor = UIColor.white
        
        self.titileColror = (self.titileColror != nil) ? self.titileColror : RGB(R: 102, G: 102, B: 102, A: 11)
        
        self.titleFont = (self.titleFont != nil) ? self.titleFont : UIFont.systemFont(ofSize: 15)
        
        self.sliderViewColor = (self.sliderViewColor != nil) ? self.sliderViewColor : Base_Orange
        
        self.selectedColor = (self.selectedColor != nil) ? selectedColor : Base_Orange
        
        self.buttonWidth  = (self.buttonWidth != nil) ? buttonWidth : 80
        
    }
  
    
    //公用方法  外部可以调用
   public func createView(titileArr:NSArray,ViewControllerArr:NSArray,RootVC:UIViewController) -> Void {
    
    
    arrcount = ViewControllerArr.count
    
    currentSelectIndex = 0
    
    let alexHeight:NSInteger = 43
    
    buttonViewArr = NSMutableArray.init()
    
    lineScrollView = UIScrollView.init()
    lineScrollView.isPagingEnabled = true
    lineScrollView.contentSize = CGSize(width: buttonWidth*ViewControllerArr.count, height: alexHeight)
    lineScrollView.frame = CGRect(x: 0, y: 0, width: Int(kScreenWidth), height: alexHeight)
    lineScrollView.showsVerticalScrollIndicator = false
    lineScrollView.showsHorizontalScrollIndicator = false
    lineScrollView.bounces = false
    lineScrollView.delegate = self

    self.addSubview(lineScrollView)
    
    pageScrollView = UIScrollView.init()
    pageScrollView.isPagingEnabled = true
    pageScrollView.contentSize = CGSize(width: titileArr.count * NSInteger(kScreenWidth), height: NSInteger(kScreenHeight))
    pageScrollView.frame = CGRect(x: 0, y: CGFloat(alexHeight), width: kScreenWidth, height: kScreenHeight)
    pageScrollView.showsHorizontalScrollIndicator = false
    pageScrollView.showsVerticalScrollIndicator = false
    pageScrollView.bounces = false
    pageScrollView.delegate = self

    self.addSubview(pageScrollView)
    
    
    //遍历创建
    for index in 0...ViewControllerArr.count-1 {
        
        let funcBtn = UIButton.init(type: UIButtonType.custom)
        
        funcBtn.setTitle(titileArr[index] as? String, for: UIControlState.normal)
        
        funcBtn.setTitleColor(self.selectedColor, for: UIControlState.selected)
        
        funcBtn.setTitleColor(self.titileColror, for: UIControlState.normal)
        
        funcBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        funcBtn.addTarget(self, action: #selector(changeAnimation(sender:)), for: UIControlEvents.touchUpInside)
        
        funcBtn.tag = index
        
        funcBtn.frame = CGRect(x: index * self.buttonWidth, y: 0, width: self.buttonWidth, height: 40)
        
        lineScrollView .addSubview(funcBtn)
        
        let controller : UIViewController = ViewControllerArr[index] as! UIViewController
        
        let childDrenView = controller.view
        
        childDrenView?.frame = CGRect(x: index * NSInteger(kScreenWidth), y: 0, width: Int(kScreenWidth), height:NSInteger(self.frame.size.height) - alexHeight)
        
        childDrenView?.tag = index
        
        RootVC.addChildViewController(controller)
        
        controller.didMove(toParentViewController: RootVC)
        
        pageScrollView.addSubview(childDrenView!)
        
        buttonViewArr.add(funcBtn)
        
    }
    
    lineView = UIView.init()
    
    let firstBtn : UIButton = buttonViewArr.firstObject as! UIButton
    
    firstBtn.isSelected = true
    
    currentSelectIndex = 0
    
    lineView.frame = CGRect(x: 0, y: 40, width: self.buttonWidth, height: 2)
    
    lineView.center = CGPoint(x: firstBtn.center.x, y: 40)
    
    lineView.backgroundColor = self.sliderViewColor
    
    lineScrollView.addSubview(lineView)
    
    //上部滑动条的底部横线
    
    let bottomlineView = UIView.init()
    
    bottomlineView.backgroundColor = UIColor.gray
    
    bottomlineView.frame = CGRect(x: 0, y:Int(NSInteger(alexHeight-1)) , width: Int(self.lineScrollView.contentSize.width+60), height: 1)
    
    lineScrollView.addSubview(bottomlineView)
    
    
    }
    

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView.isEqual(pageScrollView) {
            
            let currentPage:NSInteger = NSInteger(pageScrollView.contentOffset.x/pageScrollView.bounds.size.width)
            
            lineScrollViewScroll(currentPage: currentPage)
            
            scrollToIndex(index: currentPage)
            //滑动代理事件
            if self.delegate != nil {
                
                self.delegate?.sliderViewAndReloadData(index:Int(currentPage))
            }

        }
    }
    
    // 手动点击滑块时执行的方法  包括页面、滑动条、顶部按钮的切换
    func changeAnimation(sender:UIButton) -> Void {
        
        let index : NSInteger = sender.tag
        
        pageScrollView.contentOffset = CGPoint(x: CGFloat(index) * pageScrollView.frame.size.width, y: 0)
        
        lineScrollViewScroll(currentPage: index)
        
        scrollToIndex(index: index)

        if self.delegate != nil {
            
            self.delegate?.sliderViewAndReloadData(index: index)
        }
        
    }
    
    //滑动到指定界面
      func scrollToIndex(index:NSInteger) -> Void {
       
        if currentSelectIndex != index {
            
            let selectBtn : UIButton  = buttonViewArr.object(at: index) as! UIButton
            
            let lastSelectBtn : UIButton = buttonViewArr.object(at: currentSelectIndex) as! UIButton
            
            selectBtn.isSelected = true
            
            lastSelectBtn.isSelected = false
            
            currentSelectIndex = index
            
            UIView.animate(withDuration: 0.15) {
                
                var center : CGPoint = self.lineView.center
                
                center.x = selectBtn.center.x
                
                 self.lineView.center = center
                
            }
            
        }
       
    }
    
    //外部调用滑动方法
    
    @objc public func sliderToViewIndex(index:NSInteger) -> Void {
        
        self.pageScrollView.contentOffset = CGPoint(x: CGFloat(index) * pageScrollView.frame.size.width, y: 0)
        
        scrollToIndex(index: index)
        
        //外部代理方法
        if self.delegate != nil {
            
            self.delegate?.sliderViewAndReloadData(index: index)
        }
        
    }
    
    
    
    //顶部滑动条随着下边的滑动
    func lineScrollViewScroll(currentPage:NSInteger) -> Void {
        
        let  selectBtn : UIButton = buttonViewArr[currentPage] as! UIButton
        
        let  originX = selectBtn.frame.origin.x + selectBtn.frame.size.width
        
        UIView.animate(withDuration: 0.15) {
            
            if originX > kScreenWidth {
                
                self.lineScrollView.contentOffset = CGPoint(x: selectBtn.frame.size.width*(originX - kScreenWidth) / CGFloat(self.buttonWidth) + 30, y: 0)
            
            }else if(NSInteger(originX) <= self.buttonWidth) {
                
                self.lineScrollView.contentOffset = CGPoint(x: -selectBtn.frame.size.width/3, y: 0)
            }else{
                print("在屏幕内滑动,不做任何操作")
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
