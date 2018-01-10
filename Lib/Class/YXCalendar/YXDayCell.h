//
//  YXDayCell.h
//  Calendar
//
//  Created by Vergil on 2017/7/6.
//  Copyright © 2017年 Vergil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXDateHelpObject.h"
#import "SXYCircle.h"

static CGFloat const dayCellH = 40;//日期cell高度

typedef enum : NSUInteger {
    CalendarType_Week,
    CalendarType_Month,
} CalendarType;

@interface YXDayCell : UICollectionViewCell

@property (nonatomic, strong) NSDate *currentDate;  //当月或当周日期
@property (nonatomic, strong) NSDate *selectDate;   //选择日期
@property (nonatomic, strong) NSDate *cellDate;     //cell显示日期
@property (nonatomic, assign) CalendarType type;    //选择类型
@property (nonatomic, strong) NSArray *eventArray;  //事件数组

@property (nonatomic, strong) NSArray *investArr;//该日期中只有投资
@property (nonatomic, strong) NSArray *incomeArr;//该日期中只有回款
@property (nonatomic, strong) NSArray *mixArr;//该日期中投资和回款都有

@property (nonatomic, strong) SXYCircle *circleView;

@property (weak, nonatomic) IBOutlet UIView *pointV;    //点
@property (weak, nonatomic) IBOutlet UILabel *dayL;    //点

- (void)drawCircle;//画圆

@end
