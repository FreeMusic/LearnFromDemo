//
//  LeveyTabBar.h
//  LeveyTabBarController
//
//  Created by Levey Zhu on 12/15/10.
//  Copyright 2010 SlyFairy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QYDemoBadgeView.h"

@protocol LeveyTabBarDelegate;

@interface LeveyTabBar : UIView

@property (nonatomic, retain) UIImageView *backgroundView;//tabar背景颜色
@property (nonatomic, assign) id<LeveyTabBarDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *buttons;//tabar的个数
@property (strong, nonatomic) YSFDemoBadgeView *badgeView;

- (id)initWithFrame:(CGRect)frame;//tabar的坐标
- (void)selectTabAtIndex:(NSInteger)index;//tabar被选中
- (void)tabBarButtonClickedWithTag:(NSInteger)tag;
- (void) buttonImages:(NSArray *)imageArray;
//- (void)removeTabAtIndex:(NSInteger)index;//tabar被移除
//- (void)insertTabWithImageDic:(NSDictionary *)dict atIndex:(NSUInteger)index;


@end

@protocol LeveyTabBarDelegate<NSObject>
@optional
- (BOOL)tabBar:(LeveyTabBar *)tabBar shouldSelectIndex:(NSInteger)index;
- (void)tabBar:(LeveyTabBar *)tabBar didSelectIndex:(NSInteger)index; 
@end
