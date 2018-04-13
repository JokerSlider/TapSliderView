//
//  ViewController.m
//  TapScrollView
//
//  Created by mac on 2018/4/3.
//  Copyright © 2018年 Joker. All rights reserved.
//

#import "ViewController.h"
#import "TapSliderScrollView.h"
#import "FirstViewController.h"
#import "SecViewController.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<SliderLineViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FirstViewController *vc1 = [[FirstViewController alloc]init];
    
    SecViewController *vc2 = [[SecViewController alloc]init];
    
    TapSliderScrollView *view = [[TapSliderScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    view.delegate = self;
    //设置滑动条的颜色
    view.sliderViewColor = [UIColor greenColor];
    view.titileColror = [UIColor blackColor];
    view.selectedColor = [UIColor redColor];
    [view createView:@[@"第一个页面",@"第二个页面"] andViewArr:@[vc1,vc2] andRootVc:self];
    [self.view addSubview:view];
    
    //自动滑动到第二页
    [view sliderToViewIndex:1];
    
}
#pragma mark sliderDelegate
-(void)sliderViewAndReloadData:(NSInteger)index
{
    NSLog(@"刷新数据啦%ld",index);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
