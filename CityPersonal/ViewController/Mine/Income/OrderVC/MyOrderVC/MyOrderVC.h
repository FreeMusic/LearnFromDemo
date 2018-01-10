//
//  MyOrderVC.h
//  CityJinFu
//
//  Created by mic on 2017/6/5.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UnFinishOrderVC.h"
#import "FinishOrderVC.h"
#import "FatherVC.h"

@interface MyOrderVC : UIViewController

@property (nonatomic, strong) UnFinishOrderVC *unFinishedVC;//未完成订单
@property (nonatomic, strong) FinishOrderVC *finishedVC;//完成订单
@property (nonatomic, strong) FatherVC *fatherVC;

@end
