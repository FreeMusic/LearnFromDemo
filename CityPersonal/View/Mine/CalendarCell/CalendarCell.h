//
//  CalendarCell.h
//  CityJinFu
//
//  Created by mic on 2017/9/27.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarListModel.h"

typedef enum : NSUInteger{
    Status_Success,
    Status_CheckPass,
    Status_Fail,
    Status_IncestRepayment,
    Status_Repayment,
    Status_RepaymentSuccess,
} InvestStatus;

@interface CalendarCell : UITableViewCell

@property (nonatomic, assign) InvestStatus status;//投资状态

- (void)cellForModel:(CalendarListModel *)model;

@end
