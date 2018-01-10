//
//  MyBillRecordVC.h
//  CityJinFu
//
//  Created by mic on 2017/6/7.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyBillRecordVC : UIViewController

@property (nonatomic, assign) NSInteger section;//2为投资记录  3为回款记录、
@property (nonatomic, strong) NSString *investID;//汇款记录或者投资记录ID

@end
