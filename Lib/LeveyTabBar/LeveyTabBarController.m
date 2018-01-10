//
//  LeveyTabBarControllerViewController.m
//  LeveyTabBarController
//
//  Created by Levey Zhu on 12/15/10.
//  Copyright 2010 SlyFairy. All rights reserved.
//

#import "LeveyTabBarController.h"
#import "LeveyTabBar.h"
#import "QYDemoBadgeView.h"

@implementation UIViewController (LeveyTabBarControllerSupport)

- (LeveyTabBarController *)leveyTabBarController
{
    UIViewController *vc = self.parentViewController;
    while (vc) {
        if ([vc isKindOfClass:[LeveyTabBarController class]]) {
            return (LeveyTabBarController *)vc;
        } else if (vc.parentViewController && vc.parentViewController != vc) {
            vc = vc.parentViewController;
        } else {
            vc = nil;
        }
    }
    return nil;
}

@end

@interface LeveyTabBarController (private)<QYConversationManagerDelegate>
@property (strong, nonatomic) YSFDemoBadgeView *badgeView;
- (void)displayViewAtIndex:(NSUInteger)index;
@end

@implementation LeveyTabBarController

#pragma mark lifecycle
- (id)initWithViewControllers:(NSArray *)vcs;
{
	self = [super init];
	if (self != nil)
	{
		_viewControllers = [NSMutableArray arrayWithArray:vcs] ;
		
        _containerView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        //tabar的高度
		_transitionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, iPhoneWidth, _containerView.frame.size.height - kTabBarHeight)];
        //tabar的数量
		_tabBar = [[LeveyTabBar alloc] initWithFrame:CGRectMake(0, _containerView.frame.size.height - kTabBarHeight, iPhoneWidth, kTabBarHeight)];

		_tabBar.delegate = self;
	}
	return self;
}
- (void)initWithImgArr:(NSArray *)array{
    
    [_tabBar buttonImages:array];
    
}
/**
 *  以编程的方式创建 view 的时候用到
 */
- (void)loadView 
{
	[super loadView];
	
	[_containerView addSubview:_transitionView];
    
	[_containerView addSubview:_tabBar];
    
	self.view = _containerView;

}
/**
 *  侧滑
 */
- (void)viewDidLoad 
{
    [super viewDidLoad];
    //设置导航栏隐藏---安仔
//    self.navigationController.navigationBarHidden = YES;
    self.selectedIndex = homeIndex;
}
/**
 *  分页栏隐藏
 */
- (void)hidesTabBar:(BOOL)yesOrNO animated:(BOOL)animated;
{
    _tabBarHidden = yesOrNO;
    
    if (yesOrNO == YES) {
        if (self.tabBar.frame.origin.y == self.view.frame.size.height) {
            return;
        }
    } else {
        if (self.tabBar.frame.origin.y == self.view.frame.size.height - kTabBarHeight) {
            return;
        }
    }
    
    if (animated == YES)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3f];
    }
    float tabBarOriginY = tabBarOriginY = yesOrNO ? self.view.frame.size.height : self.view.frame.size.height - kTabBarHeight;
    
    self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x, tabBarOriginY, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
    
    _transitionView.frame = _containerView.bounds;
    
    if (animated == YES)
    {
        [UIView commitAnimations];
    }
}

/**
 *  选中的下标
 *
 *  @return index
 */
- (NSUInteger)selectedIndex
{
	return _selectedIndex;
}
/**
 *  选中的控制器和下标
 */
- (UIViewController *)selectedViewController
{
    return [_viewControllers objectAtIndex:_selectedIndex];
}
/**
 *  tabar被选中
 */
-(void)setSelectedIndex:(NSUInteger)index
{
    
   [self displayViewAtIndex:index];
     [_tabBar selectTabAtIndex:index];
}

#pragma mark - Private methods
- (void)displayViewAtIndex:(NSUInteger)index
{    
    UIViewController *targetViewController = [self.viewControllers objectAtIndex:index];
    // If target index is equal to current index.
    if (_selectedIndex == index && [[_transitionView subviews] count] != 0)
    {
        if ([targetViewController isKindOfClass:[UINavigationController class]]) {
            [(UINavigationController*)targetViewController popToRootViewControllerAnimated:YES];
        }
        return;
    }
    
    _selectedIndex = index;
    
	[_transitionView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
	targetViewController.view.frame = _transitionView.bounds;
    [self addChildViewController:targetViewController];
    [_transitionView addSubview:targetViewController.view];
    
    // Notify the delegate, the viewcontroller has been changed.
    if ([_delegate respondsToSelector:@selector(tabBarController:didSelectViewController:)])
    {
        [_delegate tabBarController:self didSelectViewController:targetViewController];
    }
}

#pragma mark tabBar delegates
- (BOOL)tabBar:(LeveyTabBar *)tabBar shouldSelectIndex:(NSInteger)index
{
    if ([_delegate respondsToSelector:@selector(tabBarController:shouldSelectViewController:)])
    {
        return [_delegate tabBarController:self shouldSelectViewController:[self.viewControllers objectAtIndex:index]];
    }
    return YES;
}
/**
 *  tabar被选中
 *  @param index  index
 */
- (void)tabBar:(LeveyTabBar *)tabBar didSelectIndex:(NSInteger)index
{
     [self displayViewAtIndex:index];
}
#pragma mark - 网易七鱼返回
- (void)onBack:(UINavigationItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - QYConversationManagerDelegate点击调用
- (void)onUnreadCountChanged:(NSInteger)count
{
    [self configBadgeView];
}
- (void)configBadgeView
{
    NSInteger count = [[[QYSDK sharedSDK] conversationManager] allUnreadCount];
    [_tabBar.badgeView setHidden:count == 0];
    NSString *value = count > 99 ? @"99+" : [NSString stringWithFormat:@"%zd",count];
    [_tabBar.badgeView setBadgeValue:value];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //网易七鱼设置代理，用来检测未读数量
    [[[QYSDK sharedSDK] conversationManager] setDelegate:self];
    [self configBadgeView];
}

@end
