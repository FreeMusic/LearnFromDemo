//
//  YXCalendarView.m
//  Calendar
//
//  Created by Vergil on 2017/7/6.
//  Copyright © 2017年 Vergil. All rights reserved.
//

#import "YXCalendarView.h"

static CGFloat const yearMonthH = 57;   //年月高度
static CGFloat const weeksH = 47;       //周高度
#define ViewW self.frame.size.width     //当前视图宽度
#define ViewH self.frame.size.height    //当前视图高度

@interface YXCalendarView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollV;    //scrollview
@property (nonatomic, assign) CalendarType type;        //选择类型
@property (nonatomic, strong) NSDate *currentDate;      //当前月份
@property (nonatomic, strong) NSDate *selectDate;       //选中日期
@property (nonatomic, strong) NSDate *tmpCurrentDate;   //记录上下滑动日期

@property (nonatomic, strong) UIView *weekView;//显示星期的View

@property (nonatomic, strong) NSString *tableViewIsHigh;//tableView是否压缩

@end

@implementation YXCalendarView

- (instancetype)initWithFrame:(CGRect)frame Date:(NSDate *)date Type:(CalendarType)type {
    
    if (self = [super initWithFrame:frame]) {
        _type = type;
        _currentDate = date;
        _selectDate = date;
        if (type == CalendarType_Week) {
            _tmpCurrentDate = date;
            _currentDate = [[YXDateHelpObject manager] getLastdayOfTheWeek:date];
        }
        [self settingViews];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeHeaderHeightToLow:) name:@"changeHeaderHeightToLow" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeHeaderHeightToHeigh:) name:@"changeHeaderHeightToHeigh" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCalendarContent:) name:@"slipToMonth" object:nil];
    }
    return self;
}

- (void)dealloc
{
    [_scrollV removeObserver:self forKeyPath:@"contentOffset"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//MARK: - setMethod

-(void)setType:(CalendarType)type {
    _type = type;
    
    _middleView.type = type;
    _leftView.type = type;
    _rightView.type = type;
    
    __weak typeof(self) weakSelf = self;
    
    UIButton *leftButton = (UIButton *)[self viewWithTag:100];
    UIButton *rightButton = (UIButton *)[self viewWithTag:101];
    
    
    if (type == CalendarType_Week) {
        //周
        if (_refreshH) {
            if (ViewH == dayCellH + weeksH) {
                return;
            }
            _refreshH(dayCellH + weeksH);
            __weak typeof(_scrollV) weakScroll = _scrollV;
            [UIView animateWithDuration:0 animations:^{
                weakScroll.frame = CGRectMake(0, yearMonthH + weeksH-57, ViewW, dayCellH);
                weakSelf.yearMonthL.frame = CGRectMake(0, 0, 0, 0);
                weakSelf.weekView.frame = CGRectMake(0, 0, ViewW, weeksH);
            }];
            
            leftButton.hidden = YES;
            rightButton.hidden = YES;
        }
    } else {
        //月
        if (_refreshH) {
            CGFloat viewH = [YXCalendarView getMonthTotalHeight:_currentDate type:CalendarType_Month];
            if (viewH == ViewH) {
                return;
            }
            _refreshH(viewH);
            __weak typeof(_scrollV) weakScroll = _scrollV;
            [UIView animateWithDuration:0.3 animations:^{
                weakScroll.frame = CGRectMake(0, yearMonthH + weeksH, ViewW, viewH - yearMonthH - weeksH);
                weakSelf.yearMonthL.frame = CGRectMake(0, 0, ViewW, yearMonthH);
                weakSelf.weekView.frame = CGRectMake(0, yearMonthH, ViewW, weeksH);
            }];
            
            leftButton.hidden = NO;
            rightButton.hidden = NO;
        }
    }
}
/**
 *  说明此时正在往上滑
 */
- (void)changeHeaderHeightToLow:(NSNotification *)noti{
    
    self.tableViewIsHigh = @"0";
    
    if (_type == CalendarType_Week) {
        return;
    }
    _tmpCurrentDate = _currentDate.copy;
    if (_selectDate && [[YXDateHelpObject manager] checkSameMonth:_selectDate AnotherMonth:_currentDate]) {
        _currentDate = [[YXDateHelpObject manager] getLastdayOfTheWeek:_selectDate];
        _middleView.currentDate = _currentDate;
        _leftView.currentDate = [[YXDateHelpObject manager]getEarlyOrLaterDate:_currentDate LeadTime:-7 Type:2];
        _rightView.currentDate = [[YXDateHelpObject manager]getEarlyOrLaterDate:_currentDate LeadTime:7 Type:2];
    } else {
        //默认第一周
        _currentDate = [[YXDateHelpObject manager] getLastdayOfTheWeek:[[YXDateHelpObject manager] GetFirstDayOfMonth:_currentDate]];
        _middleView.currentDate = _currentDate;
        _leftView.currentDate = [[YXDateHelpObject manager]getEarlyOrLaterDate:_currentDate LeadTime:-7 Type:2];
        _rightView.currentDate = [[YXDateHelpObject manager]getEarlyOrLaterDate:_currentDate LeadTime:7 Type:2];
        
    }
    self.type = CalendarType_Week;
    [self setType:_type];
}
/**
 *  说明此时正在往下滑
 */
- (void)changeHeaderHeightToHeigh:(NSNotification *)noti{
    
    self.tableViewIsHigh = @"1";
    
    if (_type == CalendarType_Month) {
        return;
    }
    //选中最后一行再上滑需要这个判断
    if (![[YXDateHelpObject manager] checkSameMonth:_tmpCurrentDate AnotherMonth:_currentDate]) {
        _currentDate = _tmpCurrentDate.copy;
    }
    _type = CalendarType_Month;
    [self setType:_type];
    [self setData];
    [self scrollToCenter];
}
//MARK: - otherMethod
+ (CGFloat)getMonthTotalHeight:(NSDate *)date type:(CalendarType)type {
    if (type == CalendarType_Week) {
        return yearMonthH + weeksH + dayCellH;
    } else {
        NSInteger rows = [[YXDateHelpObject manager] getRows:date];
        return yearMonthH + weeksH + rows * dayCellH;
    }
}
- (void)settingViews {
    [self settingHeadLabel];
    [self settingScrollView];
    [self addObserver];
}

- (void)settingHeadLabel {
    
    _yearMonthL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ViewW, yearMonthH)];
    _yearMonthL.text = [[YXDateHelpObject manager] getStrFromDateFormat:@"yyyy年MM月" Date:_currentDate];
    self.dataStr = [[YXDateHelpObject manager] getStrFromDateFormat:@"yyyy-MM" Date:_currentDate];
    self.dayStr = [[YXDateHelpObject manager] getStrFromDateFormat:@"yyyy-MM-dd" Date:_currentDate];
    _yearMonthL.textAlignment = NSTextAlignmentCenter;
    _yearMonthL.font = [UIFont systemFontOfSize:15];
    [self addSubview:_yearMonthL];
    
    NSArray *array = @[@"Calendar_left", @"Calendar_right"];
    //创建 上个月 下个月按钮
    for (int i = 0; i < array.count; i++) {
        UIButton *button = [UIButton buttonWithType:0];
        [button setImage:[UIImage imageNamed:array[i]] forState:0];
        
        [_yearMonthL addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_yearMonthL.mas_centerY);
            if (i) {
                make.right.mas_equalTo(-40*m6Scale);
            }else{
                make.left.mas_equalTo(40*m6Scale);
            }
            make.size.mas_equalTo(CGSizeMake(50*m6Scale, 50*m6Scale));
        }];
    }
    
    NSArray *weekdays = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    CGFloat weekdayW = ViewW/7;
    //平放周的View
    _weekView = [[UIView alloc] initWithFrame:CGRectMake(0, yearMonthH, kScreenWidth, weeksH)];
    _weekView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_weekView];
    //日期七个标签
    for (int i = 0; i < 7; i++) {
        UILabel *weekL = [[UILabel alloc] initWithFrame:CGRectMake(i*weekdayW, 0, weekdayW, weeksH)];
        weekL.textAlignment = NSTextAlignmentCenter;
        weekL.textColor = UIColorFromRGB(0x878787);
        weekL.font = [UIFont systemFontOfSize:30*m6Scale];
        weekL.text = weekdays[i];
        [_weekView addSubview:weekL];
    }
}
/**
 *  leftView
 */
- (YXMonthView *)leftView{
    if(!_leftView){
    CGFloat height = 6 * dayCellH;
    
    _leftView = [[YXMonthView alloc] initWithFrame:CGRectMake(0, 0, ViewW, height) Date:
                     _type == CalendarType_Month ? [[YXDateHelpObject manager] getPreviousMonth:_currentDate] :[[YXDateHelpObject manager]getEarlyOrLaterDate:_currentDate LeadTime:-7 Type:2]];
    }
    return _leftView;
}
/**
 *  rightView
 */
- (YXMonthView *)rightView{
    if(!_rightView){
    CGFloat height = 6 * dayCellH;
        _rightView = [[YXMonthView alloc] initWithFrame:CGRectMake(ViewW * 2, 0, ViewW, height) Date:
                      _type == CalendarType_Month ? [[YXDateHelpObject manager] getNextMonth:_currentDate] : [[YXDateHelpObject manager]getEarlyOrLaterDate:_currentDate LeadTime:7 Type:2]];
    }
    return _rightView;
}
/**
 *  middleView
 */
- (YXMonthView *)middleView{
    if(!_middleView){
    CGFloat height = 6 * dayCellH;
    
        _middleView = [[YXMonthView alloc] initWithFrame:CGRectMake(ViewW, 0, ViewW, height) Date:_currentDate];
    }
    return _middleView;
}
- (void)settingScrollView {
    
    _scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, yearMonthH + weeksH, ViewW, ViewH - yearMonthH - weeksH)];
    _scrollV.contentSize = CGSizeMake(ViewW * 3, 0);
    _scrollV.pagingEnabled = YES;
    _scrollV.showsHorizontalScrollIndicator = NO;
    _scrollV.showsVerticalScrollIndicator = NO;
    _scrollV.delegate = self;
    [self addSubview:_scrollV];
    
    __weak typeof(self) weakSelf = self;

    self.leftView.type = _type;
    _leftView.selectDate = _selectDate;

    self.middleView.type = _type;
    _middleView.selectDate = _selectDate;
    _middleView.sendSelectDate = ^(NSDate *selDate) {
        weakSelf.selectDate = selDate;
        if (weakSelf.sendSelectDate) {
            weakSelf.sendSelectDate(selDate);
        }
        [weakSelf setData];
    };
    //刷新当月的日历事件
    [_middleView getData:self.dataStr andCircleDate:[[YXDateHelpObject manager] getStrFromDateFormat:@"yyyyMM" Date:_currentDate] year:[[[YXDateHelpObject manager] getStrFromDateFormat:@"yyyy" Date:_currentDate] integerValue] month:[[[YXDateHelpObject manager] getStrFromDateFormat:@"MM" Date:_currentDate] integerValue]];
    
    self.rightView.type = _type;
    _rightView.selectDate = _selectDate;
    
    [_scrollV addSubview:_leftView];
    [_scrollV addSubview:_middleView];
    [_scrollV addSubview:_rightView];
    
    [self scrollToCenter];
}

- (void)setData {
    
    if (_type == CalendarType_Month) {
        _middleView.currentDate = _currentDate;
        _middleView.selectDate = _selectDate;
        _leftView.currentDate = [[YXDateHelpObject manager] getPreviousMonth:_currentDate];
        _leftView.selectDate = _selectDate;
        _rightView.currentDate = [[YXDateHelpObject manager] getNextMonth:_currentDate];
        _rightView.selectDate = _selectDate;
    } else {
        _middleView.currentDate = _currentDate;
        _middleView.selectDate = _selectDate;
        _leftView.currentDate = [[YXDateHelpObject manager] getEarlyOrLaterDate:_currentDate LeadTime:-7 Type:2];
        _leftView.selectDate = _selectDate;
        _rightView.currentDate = [[YXDateHelpObject manager] getEarlyOrLaterDate:_currentDate LeadTime:7 Type:2];
        _rightView.selectDate = _selectDate;
    }
    
    
    self.type = _type;
}
/**
 *  上个月  和下个月 按钮的点击事件
 */
- (void)changeCalendarContent:(NSNotification *)sender{
    NSInteger tag = [sender.userInfo[@"tag"] integerValue];
    switch (tag) {
        case 100:

            [self slipToTopMonth];
            
            break;
            
        case 101:
            
            [self slipToNextMonth];
            
            break;
            
        default:
            break;
    }
    
    [self scrollToCenter];
    //self.type = _type;
}
//MARK: - kvo
- (void)addObserver {
    [_scrollV addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self monitorScroll];
    }
    
}

- (void)monitorScroll {
    
    if (_scrollV.contentOffset.x > 2*ViewW -1) {
        if (_type == CalendarType_Month) {
            //左滑,下个月
            [self slipToNextMonth];
        } else {
            //下周
            _middleView.currentDate = [[YXDateHelpObject manager] getEarlyOrLaterDate:_currentDate LeadTime:7 Type:2];
            _middleView.selectDate = _selectDate;
            _leftView.currentDate = _currentDate;
            _leftView.selectDate = _selectDate;
            _currentDate = [[YXDateHelpObject manager] getEarlyOrLaterDate:_currentDate LeadTime:7 Type:2];
            _tmpCurrentDate = _currentDate.copy;
            _rightView.currentDate = [[YXDateHelpObject manager] getEarlyOrLaterDate:_currentDate LeadTime:7 Type:2];
            _rightView.selectDate = _selectDate;
            _yearMonthL.text = [[YXDateHelpObject manager] getStrFromDateFormat:@"yyyy年MM月" Date:_currentDate];
            self.dataStr = [[YXDateHelpObject manager] getStrFromDateFormat:@"yyyy-MM" Date:_currentDate];
            if (self.tableViewIsHigh.integerValue == 0) {
                UIViewController *vc = (UIViewController *)[self ViewController];
                
                [TitleLabelStyle addtitleViewToVC:vc withTitle:self.dataStr];
            }
            //刷新当月的日历事件
            [_middleView getData:self.dataStr andCircleDate:[[YXDateHelpObject manager] getStrFromDateFormat:@"yyyyMM" Date:_currentDate] year:[[[YXDateHelpObject manager] getStrFromDateFormat:@"yyyy" Date:_currentDate] integerValue] month:[[[YXDateHelpObject manager] getStrFromDateFormat:@"MM" Date:_currentDate] integerValue]];
        }
        
        [self scrollToCenter];
        self.type = _type;
        
    } else if (_scrollV.contentOffset.x < 1) {
        
        if (_type == CalendarType_Month) {
            //右滑,上个月
            [self slipToTopMonth];
        } else {
            //上周
            _middleView.currentDate = [[YXDateHelpObject manager] getEarlyOrLaterDate:_currentDate LeadTime:-7 Type:2];
            _middleView.selectDate = _selectDate;
            _rightView.currentDate = _currentDate;
            _rightView.selectDate = _selectDate;
            _currentDate = [[YXDateHelpObject manager] getEarlyOrLaterDate:_currentDate LeadTime:-7 Type:2];
            _tmpCurrentDate = _currentDate.copy;
            _leftView.currentDate = [[YXDateHelpObject manager] getEarlyOrLaterDate:_currentDate LeadTime:-7 Type:2];
            _leftView.selectDate = _selectDate;
            _yearMonthL.text = [[YXDateHelpObject manager] getStrFromDateFormat:@"yyyy年MM月" Date:_currentDate];
            self.dataStr = [[YXDateHelpObject manager] getStrFromDateFormat:@"yyyy-MM" Date:_currentDate];
            if (self.tableViewIsHigh.integerValue == 0) {
                UIViewController *vc = (UIViewController *)[self ViewController];
                
                [TitleLabelStyle addtitleViewToVC:vc withTitle:self.dataStr];
            }
            //刷新当月的日历事件
            [_middleView getData:self.dataStr andCircleDate:[[YXDateHelpObject manager] getStrFromDateFormat:@"yyyyMM" Date:_currentDate] year:[[[YXDateHelpObject manager] getStrFromDateFormat:@"yyyy" Date:_currentDate] integerValue] month:[[[YXDateHelpObject manager] getStrFromDateFormat:@"MM" Date:_currentDate] integerValue]];
        }
        
        [self scrollToCenter];
        self.type = _type;
        
    }
    
}
/**
 *  获取下个月的相关日历内容
 */
- (void)slipToNextMonth{
    self.middleView.currentDate = [[YXDateHelpObject manager] getNextMonth:_currentDate];
    _middleView.selectDate = _selectDate;
    self.leftView.currentDate = _currentDate;
    _leftView.selectDate = _selectDate;
    _currentDate = [[YXDateHelpObject manager] getNextMonth:_currentDate];
    self.rightView.currentDate = [[YXDateHelpObject manager] getNextMonth:_currentDate];
    _rightView.selectDate = _selectDate;
    _yearMonthL.text = [[YXDateHelpObject manager] getStrFromDateFormat:@"yyyy年MM月" Date:_currentDate];
    self.dataStr = [[YXDateHelpObject manager] getStrFromDateFormat:@"yyyy-MM" Date:_currentDate];
    //刷新当月的日历事件
    [_middleView getData:self.dataStr andCircleDate:[[YXDateHelpObject manager] getStrFromDateFormat:@"yyyyMM" Date:_currentDate] year:[[[YXDateHelpObject manager] getStrFromDateFormat:@"yyyy" Date:_currentDate] integerValue] month:[[[YXDateHelpObject manager] getStrFromDateFormat:@"MM" Date:_currentDate] integerValue]];
}
/**
 *  获取上个月的相关日历内容
 */
- (void)slipToTopMonth{
    self.middleView.currentDate = [[YXDateHelpObject manager] getPreviousMonth:_currentDate];
    _middleView.selectDate = _selectDate;
    self.rightView.currentDate = _currentDate;
    _rightView.selectDate = _selectDate;
    _currentDate = [[YXDateHelpObject manager] getPreviousMonth:_currentDate];
    self.leftView.currentDate = [[YXDateHelpObject manager] getPreviousMonth:_currentDate];
    _leftView.selectDate = _selectDate;
    _yearMonthL.text = [[YXDateHelpObject manager] getStrFromDateFormat:@"yyyy年MM月" Date:_currentDate];
    self.dataStr = [[YXDateHelpObject manager] getStrFromDateFormat:@"yyyy-MM" Date:_currentDate];
    //刷新当月的日历事件
    [_middleView getData:self.dataStr andCircleDate:[[YXDateHelpObject manager] getStrFromDateFormat:@"yyyyMM" Date:_currentDate] year:[[[YXDateHelpObject manager] getStrFromDateFormat:@"yyyy" Date:_currentDate] integerValue] month:[[[YXDateHelpObject manager] getStrFromDateFormat:@"MM" Date:_currentDate] integerValue]];
}
//MARK: - scrollViewMethod
- (void)scrollToCenter {
    _scrollV.contentOffset = CGPointMake(ViewW, 0);
    
    //刷新当月的日历事件
    [_middleView getData:self.dataStr andCircleDate:[[YXDateHelpObject manager] getStrFromDateFormat:@"yyyyMM" Date:_currentDate] year:[[[YXDateHelpObject manager] getStrFromDateFormat:@"yyyy" Date:_currentDate] integerValue] month:[[[YXDateHelpObject manager] getStrFromDateFormat:@"MM" Date:_currentDate] integerValue]];
    //可以在这边进行网络请求获取事件日期数组等,记得取消上个未完成的网络请求
//    NSMutableArray *array = [NSMutableArray array];
//    for (int i = 0; i < 10; i++) {
//        NSString *dateStr = [NSString stringWithFormat:@"%@-%d",[[YXDateHelpObject manager] getStrFromDateFormat:@"MM" Date:_currentDate],1 + arc4random()%28];
//        [array addObject:dateStr];
//    }
//    
//    _middleView.eventArray = array;
}
@end
