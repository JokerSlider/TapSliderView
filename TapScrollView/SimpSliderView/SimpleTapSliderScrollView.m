//
//  SimpleTapSliderScrollView.m
//  SimpleTapSliderScrollView
//
//  Created by mac on 2018/4/3.
//  Copyright © 2018年 Joker. All rights reserved.
//

#import "SimpleTapSliderScrollView.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define RGB(R,G,B)        [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1.0f]

#define Base_Orange RGB(237,120,14)   //主题橙色
@interface SimpleTapSliderScrollView()<UIScrollViewDelegate>

@end


@implementation SimpleTapSliderScrollView
{
    
    
    NSMutableArray *_buttonViewArr;

    CGFloat _width;
    
    UIView *_lineView;
    
    NSInteger  _currentSelectIndex;//当前选中

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
    }
    return self;
}


#pragma mark 创建视图
-(void)createView:(NSArray *)titleArr andViewArr:(NSArray *)viewArr andRootVc:(UIViewController *)rootVC
{
    //当前的选中下标
    _currentSelectIndex = 0;
    //滑动的底部视图
    _pageScrollView = ({
        UIScrollView *view = [UIScrollView new];
        view.pagingEnabled = YES;
        view.contentSize = CGSizeMake(titleArr.count*ScreenWidth, ScreenHeight);
        view.frame = CGRectMake(0, 43, ScreenWidth, ScreenHeight);
        view.showsVerticalScrollIndicator = NO;
        view.showsHorizontalScrollIndicator = NO;
        view.bounces = NO;
        view.delegate = self;
        view;
    });
    
    [self addSubview:_pageScrollView];

    //存放按钮的数组 --  方便在滑动时修改他的选中颜色
    _buttonViewArr = [NSMutableArray array];
    
    //滑块的宽度
    _width = ScreenWidth/titleArr.count;
    
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
        
        [self addSubview:funcBtn];
        
        UIViewController *contr=viewArr[i];
        //添加子view
        UIView *childDrenView =contr.view;
        
        childDrenView.frame = CGRectMake(i*ScreenWidth, 0, ScreenWidth, self.frame.size.height-43);
        
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
    
    _lineView.frame = CGRectMake(0, 40, _width/3, 2);

    _lineView.center = CGPointMake(firstBtn.center.x, 40);
    
    _lineView.backgroundColor = self.sliderViewColor;
    
    [self addSubview:_lineView];
    
    //底部横线
    UIView *bottomlineView = ({
        UIView *view = [UIView new];
        view.backgroundColor = RGB(239, 240, 241);
        view;
    });
    
    bottomlineView.frame = CGRectMake(0, 43, ScreenWidth, 1);
    
    [self addSubview:bottomlineView];
    
    //如果标题只有两个 那中间添加分割线
    if (titleArr.count == 2) {
        UIView *horiznView = ({
            UIView *view = [UIView new];
            view.backgroundColor = RGB(239, 240, 241);
            view;
        });
        horiznView.frame = CGRectMake(self.center.x, 0, 1, 43);
        [self addSubview:horiznView];
    }
    
}

#pragma mark SCrollViewDelegate
//滑动代理事件，滑动时修改按钮的选中位置 和  修改滑块的位置  和 修改页面
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger currentAdPage;
    
    currentAdPage= _pageScrollView.contentOffset.x/_pageScrollView.bounds.size.width;
    
    [self scrollToIndex:currentAdPage];
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(sliderViewAndReloadData:)] ) {
        
        [self.delegate sliderViewAndReloadData:currentAdPage];
        
    }

}

#pragma TapAction  手动点击滑块时执行的方法  包括页面、滑动条、顶部按钮的切换
-(void)changeAnimation:(UIButton *)sender
{
    
    NSInteger index = (NSInteger)sender.tag;
        
    self->_pageScrollView.contentOffset = CGPointMake(index * self->_pageScrollView.frame.size.width, 0);
 
    [self scrollToIndex:index];
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(sliderViewAndReloadData:)] ) {
        
        [self.delegate sliderViewAndReloadData:index];
        
    }
}
//统一方法  滑动到指定页面
-(void)scrollToIndex:(NSInteger)index
{
    //这个判断是为了解决当在同一个页面多次点击滑动控件的时候按钮选中状态取消。
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
