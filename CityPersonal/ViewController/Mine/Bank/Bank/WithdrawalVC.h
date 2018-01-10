//
//  WithdrawalVC.h
//  CityJinFu
//
//  Created by xxlc on 16/8/23.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    VCSkipFrom_MyCenter,//从个人中心跳转来（默认）
    VCSkipFrom_FaceAuthent,//从人脸识别界面跳转来
} VCSkipFrom;

@interface WithdrawalVC : UIViewController

@property (nonatomic, strong) NSString *userName;//用户姓名
@property (nonatomic, assign) NSInteger isRefresh;//校验是否在viewWillAppear  非零就刷新
@property (nonatomic, assign) VCSkipFrom skipFrom;

@end
