//
//  ActivityCenterVC.h
//  CityJinFu
//
//  Created by xxlc on 16/8/23.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityCenterVC : UIViewController

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, copy) NSString *strUrl;//跳转路径
@property (nonatomic, copy) NSString *urlName;//头部名称
@property (nonatomic, assign) BOOL isNeedLogin;//是否需要登录

@property (nonatomic, strong) NSString *invite;//用户邀请码

@end
