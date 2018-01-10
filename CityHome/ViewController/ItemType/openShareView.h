//
//  openShareView.h
//  CityJinFu
//
//  Created by mic on 16/9/29.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^clickCancelBtn)();

@interface openShareView : UIView

@property (nonatomic, copy) NSString *strUrl;//跳转路径
@property (nonatomic, copy) NSString *urlName;//头部名称

@property (nonatomic, copy) NSString *clipTag; //跳转来源
@property (nonatomic, copy) NSString *sendMessage; //发送消息

@property (nonatomic, copy) NSString *bodyMessage; //分享简介

@property (nonatomic, strong) NSString *isBanner;// 1 是banner分享  0  是 投资成功分享

@property (nonatomic, assign) BOOL cannotShare;

@property (copy,nonatomic) void(^clickCancelBtn)();
@end
