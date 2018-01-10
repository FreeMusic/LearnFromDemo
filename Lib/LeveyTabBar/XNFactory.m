//
//  XNFactory.m
//  XNDevelopmentModel
//
//  Created by TSOU on 15/12/10.
//  Copyright (c) 2015年 com.jushang. All rights reserved.
//

#import "XNFactory.h"
#import "AppDelegate.h"

@interface XNFactory ()

@property (nonatomic, strong) NSArray *array;//tabBar数组

@end

@implementation XNFactory
+(NSDictionary*)getTabImageDictForName:(NSString*)tabName
{
    //    __block NSArray *array;
    //
    //    static dispatch_once_t onceToken;
    //    dispatch_once(&onceToken, ^{
    //        [DownLoadData postGetBottonIcon:^(id obj, NSError *error) {
    //
    //            array = obj;
    //
    //            [[NSUserDefaults standardUserDefaults] setObject:obj forKey:@"tabBarArray"];
    //
    //        }];
    //    });
    //    //获取tabBar数组
    //    NSArray *tabBarArray = [HCJFNSUser objectForKey:@"tabBarArray"];
    
    NSString *normalImageName;
    NSString *highlightImageName;
    
    //NSLog(@"%@", tabBarArray);
    
    if ([tabName isEqualToString:kTab_Home])//首页
    {
        normalImageName    = @"shouye.";
        highlightImageName = @"shouye";
    }
    
    else if ([tabName isEqualToString:kTab_Product])//个人中心
    {
        normalImageName    = @"wode.";
        highlightImageName = @"wode";
    }
    else if ([tabName isEqualToString:KTab_Activity])//发现
    {
        normalImageName    = @"faxian.";
        highlightImageName = @"faxian";
    }else if ([tabName isEqualToString:kTab_Wallet]){//理财
        normalImageName    = @"licai.";
        highlightImageName = @"licai";
        
    }else{
        normalImageName    = @"";
        highlightImageName = @"";
    }
    NSMutableDictionary *imgDic = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [imgDic setObject:[UIImage imageNamed:normalImageName]      forKey:@"Default"];
    
    [imgDic setObject:[UIImage imageNamed:highlightImageName]   forKey:@"Seleted"];
    
    return imgDic;
}

+(NSArray*)getTabNavArrWithTabNameArr:(NSArray*)tabNameArr
{
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < tabNameArr.count; i++)
    {
        NSString *imageName = tabNameArr[i];
        UINavigationController *nav = [XNFactory getTabNavigationControllerForName:imageName];
        
        [arr addObject:nav];
    }
    
    return arr;
}

+ (UINavigationController*)getTabNavigationControllerForName:(NSString*)tabName
{
    //    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    UINavigationController *nav = nil;
    
    UIViewController *viewController = nil;
    
    if ([tabName isEqualToString:kTab_Home])
    {
        viewController = [[HomeViewController alloc]init];
        
        NSDictionary *dic = @{
                              @"viewCtr" : viewController
                              };
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"selectViewController" object:nil userInfo:dic];
    }
    else if ([tabName isEqualToString:KTab_Activity])
    {
        viewController = [[ClipActivityController alloc] init];
    }
    else if ([tabName isEqualToString:kTab_Product])
    {
        //        NSUserDefaults *user = HCJFNSUser;
        //        if ([[user objectForKey:@"result"] isEqualToString:@"success"]) {
        viewController = [MyViewController new];
        //        }else{
        //            viewController = [[SignViewController alloc]init];
        //        }
    }else if ([tabName isEqualToString:kTab_Wallet]){
        viewController = [[CityWalletVC alloc] init];
    }
    
    
    
    
    
    nav = [[UINavigationController alloc] initWithRootViewController:viewController] ;
    
    
    //    AppDelegate *delegate1 = (AppDelegate*)[UIApplication sharedApplication].delegate;
    //    nav.delegate = delegate1;
    return nav;
}

/**
 *  主页被选中
 */
- (void)trasnformViewCtr:(UIViewController *)ctr {
    
    _selectCtr = (ItemTypeVC *)ctr;
    
}

@end
