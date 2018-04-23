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
#import "ThreeViewController.h"
#import "ForthViewController.h"
#import "FiveViewController.h"
#import "SixViewController.h"
#import "TapScrollView-Swift.h"

#import "SimpleTapSliderScrollView.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<SliderLineViewDelegate,SimpleSliderLineViewDelegate>

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

    /**<***************************************    OC版本   多个页面的初始化方法  大于3个  ****************************************>*/
    /*
    TapSliderScrollView *view = [[TapSliderScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    view.delegate = self;
    view.sliderViewColor = [UIColor greenColor];
    view.titileColror = [UIColor blackColor];
    view.selectedColor = [UIColor redColor];
    view.btnWidth = 60;//控件宽度
    [view createView:@[@"精品1",@"精品2",@"精品3",@"精品4",@"精品5"] andViewArr:@[vc1,vc2,vc3,vc4,vc5] andRootVc:self];
    [self.view addSubview:view];
    [view sliderToViewIndex:1];
    */
    
    ///<***************************************    Swift 版本   多于3个页面的初始化方法  ****************************************>
    /*
        SegmentView *view = [[SegmentView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        view.delegate = self;
        view.sliderViewColor = [UIColor greenColor];
        view.titileColror = [UIColor blackColor];
        view.selectedColor = [UIColor redColor];
        [view createViewWithTitileArr:@[@"精品1",@"精品2",@"精品3",@"精品4",@"精品5"] ViewControllerArr:@[vc1,vc2,vc3,vc4,vc5] RootVC:self];
        [self.view addSubview:view];
    
        [view sliderToViewIndex:1];
    */
    
    ///<***************************************   OC版本   最多3个页面的初始化方法  均分屏幕宽 ****************************************>
    SimpleTapSliderScrollView *simpleview = [[SimpleTapSliderScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    simpleview.delegate = self;
    simpleview.sliderViewColor = [UIColor greenColor];
    simpleview.titileColror = [UIColor blackColor];
    simpleview.selectedColor = [UIColor redColor];
    [simpleview createView:@[@"精品1",@"精品2"] andViewArr:@[vc1,vc2] andRootVc:self];
    [self.view addSubview:simpleview];
    
    [simpleview sliderToViewIndex:1];
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
