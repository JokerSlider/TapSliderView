//
//  ViewController.m
//  TapScrollView
//
//  Created by mac on 2018/4/3.
//  Copyright © 2018年 Joker. All rights reserved.
//

#import "ViewController.h"
//#import "TapSliderScrollView.h"
#import "FirstViewController.h"
#import "SecViewController.h"
#import "ThreeViewController.h"
#import "ForthViewController.h"
#import "FiveViewController.h"
#import "SixViewController.h"
#import "TapScrollView-Swift.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<SliderLineViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FirstViewController *vc1 = [[FirstViewController alloc]init];
    
    SecViewController *vc2 = [[SecViewController alloc]init];
    
    ThreeViewController *vc3 = [[ThreeViewController alloc]init];

    ForthViewController *vc4 = [[ForthViewController alloc]init];
    
    FiveViewController *vc5 = [[FiveViewController alloc]init];

    SixViewController *vc6 = [[SixViewController alloc]init];

    FirstViewController *vc7 = [[FirstViewController alloc]init];

    FirstViewController *vc8 = [[FirstViewController alloc]init];

    FirstViewController *vc9 = [[FirstViewController alloc]init];

    FirstViewController *vc10 = [[FirstViewController alloc]init];

    SecViewController *vc11 = [[SecViewController alloc]init];

    SecViewController *vc12 = [[SecViewController alloc]init];

    /*  OC 版本的初始化方法
    TapSliderScrollView *view = [[TapSliderScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    view.delegate = self;
    //设置滑动条的颜色
    view.sliderViewColor = [UIColor greenColor];
    view.titileColror = [UIColor blackColor];
    view.selectedColor = [UIColor redColor];
    view.btnWidth = 60;//控件宽度
    [view createView:@[@"精品1",@"精品2",@"精品3",@"精品4",@"精品5",@"精品6",@"精品7",@"精品8",@"精品9",@"精品10",@"精品11",@"精品12"] andViewArr:@[vc1,vc2,vc3,vc4,vc5,vc6,vc7,vc8,vc9,vc10,vc11,vc12] andRootVc:self];
    [self.view addSubview:view];

    //自动滑动到第二页
    [view sliderToViewIndex:1];
    
     */
    SegmentView *view = [[SegmentView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    view.delegate = self;
    //设置滑动条的颜色
    view.sliderViewColor = [UIColor greenColor];
    view.titileColror = [UIColor blackColor];
    view.selectedColor = [UIColor redColor];
//    view.b
    
    
    [view createViewWithTitileArr:@[@"精品1",@"精品2",@"精品3",@"精品4",@"精品5",@"精品6",@"精品7",@"精品8",@"精品9",@"精品10",@"精品11",@"精品12"] ViewControllerArr:@[vc1,vc2,vc3,vc4,vc5,vc6,vc7,vc8,vc9,vc10,vc11,vc12] RootVC:self];
    [self.view addSubview:view];
    //自动滑动到第二页
    [view sliderToViewIndexWithIndex:1];
    
}
#pragma mark sliderDelegate -- OC
-(void)sliderViewAndReloadData:(NSInteger)index
{
    NSLog(@"刷新数据啦%ld",index);
}
#pragma mark sliderDelegate  - swift

-(void)sliderViewAndReloadDataWithIndex:(NSInteger)index
{
    
    NSLog(@"刷新数据啦%ld",index);

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
