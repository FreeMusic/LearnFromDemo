//
//  FinalDecisionVC.h
//  CityJinFu
//
//  Created by mic on 2017/11/28.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
//枚举审核成功 失败  审核中 三种状态
typedef NS_ENUM(NSUInteger, FinalDecision){
    FinalDecision_Success,//审核成功
    FinalDecision_Failure,//审核失败
    FinalDecision_Wait,//审核中
};

@interface FinalDecisionVC : UIViewController

@property (nonatomic, assign) FinalDecision decision;//审核结果

@property (nonatomic, strong) NSString *bizNo;//人脸识别因子

@end
