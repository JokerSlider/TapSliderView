//
//  TapSliderScrollView.m
//  TapScrollView
//
//  Created by mac on 2018/4/3.
//  Copyright © 2018年 Joker. All rights reserved.
//

#import "TapSliderScrollView.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define RGB(R,G,B)        [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1.0f]

#define Base_Orange RGB(237,120,14)   //主题橙色
@interface TapSliderScrollView()<UIScrollViewDelegate>

@end


@implementation TapSliderScrollView
{
    
    
    NSMutableArray *_buttonViewArr;

    CGFloat _width;
    
    UIView *_lineView;
    
    NSInteger  _currentSelectIndex;//当前选中
    
    NSInteger  _arrayCount;//数量

}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.frame = frame;

        self.backgroundColor = [UIColor whiteColor];
        //顶部按钮的标题颜色  外部填入，若没有则有默认值
        self.titileColror = self.titileColror ? self.titileColror:RGB(102,102,102);
        //顶部标题的标题字体大小  外部传入  若没有有默认值
        self.titlleFont = self.titlleFont ? self.titlleFont : [UIFont systemFontOfSize:15];
        //底部滑块的颜色    外部传入 ，没有存在默认值
        self.sliderViewColor = self.sliderViewColor ? self.sliderViewColor : Base_Orange;
        //button选中的颜色
        self.selectedColor = self.selectedColor? self.selectedColor : Base_Orange;
        
        //控件宽度
        self.btnWidth = self.btnWidth? self.btnWidth : 80;
    }
    return self;
}


#pragma mark 创建视图
-(void)createView:(NSArray *)titleArr andViewArr:(NSArray *)viewArr andRootVc:(UIViewController *)rootVC
{
    
    _arrayCount = viewArr.count;
    //当前的选中下标
    _currentSelectIndex = 0;
    
    CGFloat alexHeight = 43;
    
    //存放按钮的数组 --  方便在滑动时修改他的选中颜色
    _buttonViewArr = [NSMutableArray array];
    //滑块的宽度
    _width = self.btnWidth;
    
    _lineScrollView = ({
        UIScrollView *view = [UIScrollView new];
        view.pagingEnabled = YES;
        view.contentSize = CGSizeMake(titleArr.count*_width, alexHeight);
        view.frame = CGRectMake(0, 0, ScreenWidth, alexHeight);
        view.showsVerticalScrollIndicator = NO;
        view.showsHorizontalScrollIndicator = NO;
        view.bounces = NO;
        view.delegate = self;
        view;
    });
    
    [self addSubview:_lineScrollView];
    
    //滑动的底部视图
    _pageScrollView = ({
        UIScrollView *view = [UIScrollView new];
        view.pagingEnabled = YES;
        view.contentSize = CGSizeMake(titleArr.count*ScreenWidth, ScreenHeight);
        view.frame = CGRectMake(0, alexHeight, ScreenWidth, ScreenHeight);
        view.showsVerticalScrollIndicator = NO;
        view.showsHorizontalScrollIndicator = NO;
        view.bounces = NO;
        view.delegate = self;
        view;
    });
    
    [self addSubview:_pageScrollView];
    
    //遍历外部传入的标题数组  创建顶部button
    for (int i = 0; i<titleArr.count; i++) {
        
        UIButton *funcBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [funcBtn setTitle:titleArr[i] forState:UIControlStateNormal];
        
        [funcBtn setTitleColor:self.selectedColor forState:UIControlStateSelected];
        
        [funcBtn setTitleColor:self.titileColror forState:UIControlStateNormal];
        
        funcBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        [funcBtn addTarget:self action:@selector(changeAnimation:) forControlEvents:UIControlEventTouchUpInside];
        
        funcBtn.tag = i;
        
        funcBtn.frame = CGRectMake(i*_width, 0, _width, 40);
        
        [_lineScrollView addSubview:funcBtn];
        
        UIViewController *contr=viewArr[i];
        //添加子view
        UIView *childDrenView =contr.view;
        
        childDrenView.frame = CGRectMake(i*ScreenWidth, 0, ScreenWidth, self.frame.size.height-alexHeight);
        
        childDrenView.tag =  i;
        
        [rootVC addChildViewController:contr];
        
        [contr didMoveToParentViewController:rootVC];
        
        [_pageScrollView addSubview:childDrenView];
        
        [_buttonViewArr addObject:funcBtn];
    }
    
    _lineView = [UIView new];
    
    UIButton *firstBtn = _buttonViewArr.firstObject;
    
    firstBtn.selected = YES;
    
    _currentSelectIndex = 0;
    
    _lineView.frame = CGRectMake(0, 40, _width, 2);

    _lineView.center = CGPointMake(firstBtn.center.x, 40);
    
    _lineView.backgroundColor = self.sliderViewColor;
    
    [_lineScrollView addSubview:_lineView];
    
    //底部横线
    UIView *bottomlineView = ({
        UIView *view = [UIView new];
        view.backgroundColor = RGB(239, 240, 241);
        view;
    });
    
    bottomlineView.frame = CGRectMake(0, alexHeight, ScreenWidth, 1);
    
    [_lineScrollView addSubview:bottomlineView];

    
}

#pragma mark SCrollViewDelegate
//滑动代理事件，滑动时修改按钮的选中位置 和  修改滑块的位置  和 修改页面
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if ([scrollView isEqual:_pageScrollView]) {
        
        NSInteger currentAdPage;
        
        currentAdPage= _pageScrollView.contentOffset.x/_pageScrollView.bounds.size.width;
        
        //滑动顶端视图
        [self lineScroViewScroll:currentAdPage];
        
        [self scrollToIndex:currentAdPage];
        
        if (self.delegate&&[self.delegate respondsToSelector:@selector(sliderViewAndReloadData:)] ) {
            
            [self.delegate sliderViewAndReloadData:currentAdPage];
        }
        
       
    }else{
        
        NSLog(@"我是顶端的");
    }
}
#pragma mark 顶端滑动
-(void)lineScroViewScroll:(NSInteger)currentAdPage
{
    
    //顶端的滑动视图    超过屏幕宽度自动计算宽度并进行滑动
    
    UIButton *selectBtn = _buttonViewArr[currentAdPage];
    
    CGFloat  originX = selectBtn.frame.origin.x + selectBtn.frame.size.width;
    
    [UIView animateWithDuration:0.15 animations:^{
        
        if (originX > ScreenWidth) {
            
            self->_lineScrollView.contentOffset = CGPointMake(selectBtn.frame.size.width*(originX - ScreenWidth)/self.btnWidth+30, 0);
            
        }else if(originX<=self.btnWidth) {
            
            self->_lineScrollView.contentOffset = CGPointMake(-selectBtn.frame.size.width/2, 0);
            
        }
        
    } completion:^(BOOL finished) {
        
        
    }];
    
    
    
}
#pragma TapAction  手动点击滑块时执行的方法  包括页面、滑动条、顶部按钮的切换
-(void)changeAnimation:(UIButton *)sender
{
    
    NSInteger index = (NSInteger)sender.tag;
        
    self->_pageScrollView.contentOffset = CGPointMake(index * self->_pageScrollView.frame.size.width, 0);
    
    //顶端控件跟随滑
    [self lineScroViewScroll:index];
    
    //滑动到指定页面
    [self scrollToIndex:index];
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(sliderViewAndReloadData:)] ) {
        
        [self.delegate sliderViewAndReloadData:index];
        
    }
}
#pragma mark  统一方法  滑动到指定页面
-(void)scrollToIndex:(NSInteger)index
{
    
    if (_currentSelectIndex != index) {
        
        UIButton *selectBtn = _buttonViewArr[index];
        
        UIButton *lastSelectBtn = _buttonViewArr[_currentSelectIndex];
        
        selectBtn.selected = YES;
        
        lastSelectBtn.selected = NO;
        
        _currentSelectIndex = index;
        //点击滑动scroView
        [UIView animateWithDuration:0.15 animations:^{
            
            CGPoint center = self->_lineView.center;
            
            center.x = selectBtn.center.x;
            
            self->_lineView.center = center;
            
        } completion:^(BOOL finished) {
            
            
        }];
    }

}
#pragma mark 外部滑动的方法 主动调用
-(void)sliderToViewIndex:(NSInteger)index
{

    
    self->_pageScrollView.contentOffset = CGPointMake(index * self->_pageScrollView.frame.size.width, 0);
    
    [self scrollToIndex:index];
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(sliderViewAndReloadData:)] ) {
        
        [self.delegate sliderViewAndReloadData:index];
        
    }
}



















@end
