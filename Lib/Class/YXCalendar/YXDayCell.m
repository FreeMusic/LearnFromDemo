//
//  YXDayCell.m
//  Calendar
//
//  Created by Vergil on 2017/7/6.
//  Copyright © 2017年 Vergil. All rights reserved.
//

#import "YXDayCell.h"


@interface YXDayCell ()

@property (nonatomic, assign) BOOL isDrawInvest;
@property (nonatomic, assign) BOOL isDrawIncome;
@property (nonatomic, assign) BOOL isDrawMix;

@end

@implementation YXDayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _dayL.layer.cornerRadius = 30 / 2;
    _pointV.layer.cornerRadius = 1.5;
    _pointV.hidden = YES;
    
    _circleView = [[SXYCircle alloc] init];
    [_dayL addSubview:_circleView];
    [_circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_dayL.mas_centerX);
        make.centerY.mas_equalTo(_dayL.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    self.isDrawMix = YES;
    self.isDrawIncome = YES;
    self.isDrawInvest = YES;
    
}
//MARK: - setmethod
- (void)setCellDate:(NSDate *)cellDate {
    _cellDate = cellDate;
    if (_type == CalendarType_Week) {
        [self showDateFunction];
    } else {
        if ([[YXDateHelpObject manager] checkSameMonth:_cellDate AnotherMonth:_currentDate]) {
            [self showDateFunction];
        } else {
            [self showSpaceFunction];
        }
    }
}

//MARK: - otherMethod
- (void)showSpaceFunction {
    self.circleView.hidden = YES;
    _dayL.text = @"";
    _dayL.backgroundColor = [UIColor clearColor];
    _dayL.layer.borderWidth = 0;
    _dayL.layer.borderColor = [UIColor clearColor].CGColor;
}

- (void)showDateFunction {
    
    _dayL.text = [[YXDateHelpObject manager] getStrFromDateFormat:@"d" Date:_cellDate];
    
    if ([[YXDateHelpObject manager] isSameDate:_cellDate AnotherDate:[NSDate date]]) {
        //        _dayL.layer.borderWidth = 1.5;
        //        _dayL.layer.borderColor = Colorful(253.0, 182.0, 21.0).CGColor;
    } else {
        //        _dayL.layer.borderWidth = 0;
        //        _dayL.layer.borderColor = [UIColor clearColor].CGColor;
    }
    if (_selectDate) {
        
        if ([[YXDateHelpObject manager] isSameDate:_cellDate AnotherDate:_selectDate]) {
            _dayL.backgroundColor = Colorful(253.0, 182.0, 21.0);
            _dayL.textColor = [UIColor whiteColor];
        } else {
            _dayL.backgroundColor = [UIColor clearColor];
            _dayL.textColor = [UIColor blackColor];
        }
        
    }
    NSString *currentDate = [[YXDateHelpObject manager] getStrFromDateFormat:@"MM-dd" Date:_cellDate];
    
    if (_eventArray.count) {
        for (NSString *strDate in _eventArray) {
            if ([strDate isEqualToString:currentDate]) {
                
            }
        }
    }
    
}

- (void)drawCircle{
    self.circleView.hidden = YES;
    
    NSString *currentDate = [[YXDateHelpObject manager] getStrFromDateFormat:@"yyyyMMdd" Date:_cellDate];
    
    if (self.incomeArr.count){
        for (NSString *strDAte in self.incomeArr) {
            if ([currentDate isEqualToString:strDAte]) {
                self.circleView.hidden = NO;
                [_circleView createCricleByLocationisTop:NO color:UIColorFromRGB(0x4aa2fc) wholeCircle:YES];
                //[_circleView stareAnimationWithPercentage:1];
            }
        }
    }
    
    if(self.mixArr.count){
        
        for (NSString *strDAte in self.mixArr) {
            if ([currentDate isEqualToString:strDAte]) {
                self.circleView.hidden = NO;
                [_circleView createCricleByLocationisTop:NO color:UIColorFromRGB(0xff6b69) wholeCircle:NO];
                //[_circleView stareAnimationWithPercentage:0.5];
                
                [_circleView createCricleByLocationisTop:YES color:UIColorFromRGB(0x4aa2fc) wholeCircle:NO];
                //[_circleView stareAnimationWithPercentage:0.5];
                
            }
        }
    }
    
    if (self.investArr.count) {
        for (NSString *strDAte in self.investArr) {
            if ([currentDate isEqualToString:strDAte]) {
                self.circleView.hidden = NO;
                [_circleView createCricleByLocationisTop:NO color:UIColorFromRGB(0xff6b69) wholeCircle:YES];
                //[_circleView stareAnimationWithPercentage:1];
            }
        }
    }
}

@end
