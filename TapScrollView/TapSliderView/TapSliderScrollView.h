//
//  TapSliderScrollView.h
//  TapScrollView
//
//  Created by mac on 2018/4/3.
//  Copyright © 2018年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  SliderLineViewDelegate <NSObject>

@required

-(void)sliderViewAndReloadData:(NSInteger)index;

@end

@interface TapSliderScrollView : UIView

@property (nonatomic,strong)    UIScrollView *pageScrollView;

@property (nonatomic,weak)id <SliderLineViewDelegate> delegate;

@property (nonatomic,copy)UIColor  *titileColror;//字体颜色

@property (nonatomic,copy)UIFont   *titlleFont;//按钮的字体大小

@property (nonatomic,copy)UIColor  *sliderViewColor;//滑动条颜色

@property (nonatomic,copy)UIColor  *selectedColor;//button选中的颜色

/**
 初始化创建方法

 @param titleArr 标题
 @param viewArr 视图数组 传入 视图控制器
 @param rootVC 当前的视图 一般为self
 */
-(void)createView:(NSArray *)titleArr andViewArr:(NSArray *)viewArr andRootVc:(UIViewController *)rootVC;

/**
 手动  或者 外部滑动的方法

 @param index 下标
 */
-(void)sliderToViewIndex:(NSInteger)index;

@end
