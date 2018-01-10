//
//  XNFactory.h
//  XNDevelopmentModel
//
//  Created by TSOU on 15/12/10.
//  Copyright (c) 2015年 com.jushang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemTypeVC.h"
#import "SignViewController.h"
#import "MyViewController.h"
#import "HomeViewController.h"
#import "ClipActivityController.h"
#import "CityWalletVC.h"

@interface XNFactory : NSObject<UINavigationControllerDelegate>

@property (nonatomic, strong) ItemTypeVC *selectCtr;

//tabName
+(NSDictionary*)getTabImageDictForName:(NSString*)tabName;

+(NSArray*)getTabNavArrWithTabNameArr:(NSArray*)tabNameArr;

+(NSArray*)getTabImageArrWithTabNameArr:(NSArray*)imageArr;



@end
