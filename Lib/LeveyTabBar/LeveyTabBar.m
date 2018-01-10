//
//  LeveyTabBar.m
//  LeveyTabBarController
//
//  Created by zhang on 12-10-10.
//  Copyright (c) 2012年 jclt. All rights reserved.
//
//

#import "LeveyTabBar.h"
#import "AppDelegate.h"
#import "NewSignVC.h"
#import "MyBackView.h"

@interface LeveyTabBar ()

@property (nonatomic, strong) MyBackView *myBackView;

@property (nonatomic, assign) NSInteger clipIndex;

@end

@implementation LeveyTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //添加网易七鱼客服消息未读数量
        //         _badgeView = [[YSFDemoBadgeView alloc] init];
        self.backgroundColor = [UIColor clearColor];
        _backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backgroundView.backgroundColor = [UIColor whiteColor];//tabar背景颜
        _backgroundView.layer.borderWidth = 0.5;
        _backgroundView.layer.borderColor = [UIColor colorWithRed:227 / 255.0 green:226 / 255.0 blue:226 / 255.0 alpha:1].CGColor;
        [self addSubview:_backgroundView];
        
        
    }
    return self;
}
- (void) buttonImages:(NSArray *)imageArray{
    self.buttons = [NSMutableArray arrayWithCapacity:[imageArray count]];
    //tabar的坐标布局
    UIButton *btn;
    CGFloat width = iPhoneWidth / 4;//宽度
    for (int i = 0; i < 4; i++)
    {
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        btn.frame = CGRectMake(width * i+(width-78*m6Scale)/2, (kTabBarHeight-78*m6Scale)/2, 78*m6Scale, 78*m6Scale);
        //tabar图片
        [btn setImage:[[imageArray objectAtIndex:i] objectForKey:@"Default"] forState:UIControlStateNormal];
        [btn setImage:[[imageArray objectAtIndex:i] objectForKey:@"Seleted"] forState:UIControlStateSelected];
        //            btn.layer.borderWidth = 0.5;
        //            btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        //点击事件
        [btn addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
        [self.buttons addObject:btn];
        [self addSubview:btn];
        //            if (i == imageArray.count -1) {
        //                if (btn.tag == imageArray.count -1) {
        //                    [btn addSubview:_badgeView];
        //                    [_badgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        //                        make.right.mas_equalTo(btn.mas_right).mas_equalTo(-70*m6Scale);
        //                        make.top.mas_equalTo(btn.mas_top).mas_equalTo(10*m6Scale);
        //                        make.size.mas_equalTo(CGSizeMake(20*m6Scale, 20*m6Scale));
        //                    }];
        //                }
        //            }
    }
    
}
/**
 *  根据tag值来判断哪个被选中
 *
 *  @param sender tag值
 */
- (void)tabBarButtonClicked:(id)sender
{
    UIButton *btn = sender;
    [self selectTabAtIndex:btn.tag];
    
    if ([_delegate respondsToSelector:@selector(tabBar:didSelectIndex:)])
    {
        
        if (btn.tag == 3) {
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            
            if ([user objectForKey:@"userId"]) {
                
                [_delegate tabBar:self didSelectIndex:btn.tag];
                
            }else {
                [_delegate tabBar:self didSelectIndex:3];
//                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//                UINavigationController *navi = [delegate.leveyTabBarController.viewControllers lastObject];
//                UIViewController *vc = [navi.viewControllers firstObject];
//                _myBackView = [[MyBackView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
//                MyViewController *tempVC = [MyViewController new];
//                
//                [vc.navigationController.navigationBar addSubview:_myBackView];
                //                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                //                UINavigationController *navi = [delegate.leveyTabBarController.viewControllers firstObject];
                //                UIViewController *vc = [navi.viewControllers firstObject];
                //                SignViewController *signVC = [[SignViewController alloc] init];
                //                signVC.presentTag = @"0";
                //                [vc presentViewController:signVC animated:YES completion:nil];
            }
            
            
        }else {
            
            [_delegate tabBar:self didSelectIndex:btn.tag];
        }
    }
}
- (void)tabBarButtonClickedWithTag:(NSInteger)tag {
    
    if (tag == 3) {
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        
        if ([user objectForKey:@"userId"]) {
            
            [_delegate tabBar:self didSelectIndex:tag];
            
        }else {
            
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            UINavigationController *navi = [delegate.leveyTabBarController.viewControllers firstObject];
            UIViewController *vc = [navi.viewControllers firstObject];
            NewSignVC *signVC = [[NewSignVC alloc] init];
            signVC.presentTag = @"0";
            [vc presentViewController:signVC animated:YES completion:nil];
        }
    }
    
    
}
/**
 *  tabar按钮切换颜色的变化
 *
 *  @param index tag值
 */
- (void)selectTabAtIndex:(NSInteger)index
{
    
    for (int i = 0; i < [self.buttons count]; i++)
    {
        
        UIButton *button = [self.buttons objectAtIndex:i];
        button.selected = NO;
        button.userInteractionEnabled = YES;
    }
    
    //     NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    //    if (index == 3) {
    //
    //        if ([user objectForKey:@"userId"]) {
    //
    //            index = 3;
    //        }else {
    //            
    //            if (self.clipIndex) {
    //                
    //                index = self.clipIndex;
    //            }else {
    //                
    //                index = 0;
    //            }
    //            
    //            
    //        }
    //        
    //    }
    self.clipIndex = index;
    UIButton *btn = [self.buttons objectAtIndex:index];
    btn.selected = YES;
    btn.userInteractionEnabled = NO;
}

@end
