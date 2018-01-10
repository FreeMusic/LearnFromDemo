//
//  CurrentBillRecordVC.h
//  CityJinFu
//
//  Created by mic on 2017/6/11.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrentBillRecordVC : UIViewController

@property (nonatomic,assign) NSInteger type;//2是本月投资记录 3是本月回款记录

@property (nonatomic,strong) NSString *dataString;//日期

@end
