//
//  LeveyTabBarControllerViewController.h
//  LeveyTabBarController
//
//  Created by Levey Zhu on 12/15/10.
//  Copyright 2010 SlyFairy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeveyTabBar.h"
@class UITabBarController;
@protocol LeveyTabBarControllerDelegate;

@interface LeveyTabBarController : UIViewController <LeveyTabBarDelegate>
{
	LeveyTabBar *_tabBar;
	UIView      *_containerView;
	UIView		*_transitionView;
	NSMutableArray *_viewControllers;
	NSUInteger _selectedIndex;
}

@property(nonatomic, strong) NSMutableArray *viewControllers;

//@property(nonatomic) NSUInteger selectedIndex;

// Apple is readonly
@property (nonatomic, readonly) LeveyTabBar *tabBar;
@property(nonatomic,assign) id<LeveyTabBarControllerDelegate> delegate;

// Default is NO, if set to YES, content will under tabbar
@property (nonatomic) BOOL tabBarTransparent;
@property (nonatomic) BOOL tabBarHidden;
- (void)hidesTabBar:(BOOL)yesOrNO animated:(BOOL)animated;
/**
 *  控制器的个数和图片
 */
- (id)initWithViewControllers:(NSArray *)vcs;

- (void)initWithImgArr:(NSArray *)array;

@property(nonatomic) NSUInteger selectedIndex;

@end


@protocol LeveyTabBarControllerDelegate <NSObject>
@optional
/**
 *  控制器将要被选中
 */
- (BOOL)tabBarController:(LeveyTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController;
/**
 * 控制器被选中
 */
- (void)tabBarController:(LeveyTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;

@end

@interface UIViewController (LeveyTabBarControllerSupport)
@property(nonatomic, retain, readonly) LeveyTabBarController *leveyTabBarController;
@end

