//
//  AuthenticationVC.h
//  CityJinFu
//
//  Created by mic on 2017/11/27.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "PopModalFatherVC.h"

//枚举身份认证界面 是否需要 人工审核
typedef enum : NSUInteger {
    NeedReview_YES,//需要人工审核
    NeedReview_NO,//不需要人工审核
} ReViewType;
//目前项目中只有 进提现页面 和 进账户设置 身份认证页面 需要用到人脸识别
typedef enum : NSUInteger {
    SkipFromVC_MyCenter,//从个人中心----提现
    SkipFromVC_AccountSet,//从账户设置----身份认证
} SkipFromVC;

@interface AuthenticationVC : PopModalFatherVC

@property (nonatomic, strong) NSString *bizNo;//人脸识别因子

@property (nonatomic, assign) ReViewType reviewType;//身份认证类型

@property (nonatomic, assign) SkipFromVC skipFromVC;//目前项目中只有 进提现页面 和 进账户设置 身份认证页面 需要用到人脸识别

@end
