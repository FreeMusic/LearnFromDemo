//
//  YXMonthView.m
//  Calendar
//
//  Created by Vergil on 2017/7/6.
//  Copyright © 2017年 Vergil. All rights reserved.
//

#import "YXMonthView.h"

@interface YXMonthView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionV;

@property (nonatomic, assign) NSInteger monthMaxDay;//该月的最大天数

@property (nonatomic, strong) NSDictionary *dataSource;//请求的数据中  有回款和投资数据

@property (nonatomic, strong) NSMutableArray *investArr;//该日期中只有投资
@property (nonatomic, strong) NSMutableArray *incomeArr;//该日期中只有回款
@property (nonatomic, strong) NSMutableArray *mixArr;//该日期中投资和回款都有
@property (nonatomic, strong) NSMutableArray *allArr;//该数组中有该月的所有日期

@property (nonatomic, strong) NSString *dateMonth;

@property (nonatomic, strong) NSIndexPath *selectIndex;

@property (nonatomic, assign) BOOL isAllowDrawCircle;

@end

@implementation YXMonthView

- (instancetype)initWithFrame:(CGRect)frame Date:(NSDate *)date {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _currentDate = date;
        [self setCollectionView];
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeHeaderHeightToLow) name:@"changeHeaderHeightToLow" object:nil];
//        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeHeaderHeightToHeigh) name:@"changeHeaderHeightToHeigh" object:nil];
    }
    return self;
}
/**
 * 该日期中只有投资
 */
- (NSMutableArray *)investArr{
    if(!_investArr){
        _investArr = [NSMutableArray array];
    }
    return _investArr;
}
/**
 *  该日期中只有回款
 */
- (NSMutableArray *)incomeArr{
    if(!_incomeArr){
        _incomeArr = [NSMutableArray array];
    }
    return _incomeArr;
}
/**
 *  该日期中投资和回款都有
 */
- (NSMutableArray *)mixArr{
    if(!_mixArr){
        _mixArr = [NSMutableArray array];
    }
    return _mixArr;
}
/**
 *  该数组中有该月的所有日期
 */
- (NSMutableArray *)allArr{
    if(!_allArr){
        _allArr = [NSMutableArray array];
    }
    return _allArr;
}
//MARK: - settingView
- (void)setCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake((self.frame.size.width - 1) / 7, dayCellH);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 6 * dayCellH) collectionViewLayout:layout];
    _collectionV.scrollEnabled = NO;
    _collectionV.delegate = self;
    _collectionV.dataSource = self;
    _collectionV.backgroundColor = [UIColor whiteColor];
    [self addSubview:_collectionV];
    
    [_collectionV registerNib:[UINib nibWithNibName:@"YXDayCell" bundle:nil] forCellWithReuseIdentifier:@"YXDayCell"];
    
}
- (void)changeHeaderHeightToLow{
    
    _type = CalendarType_Week;
    
}
- (void)changeHeaderHeightToHeigh{
    
    _type = CalendarType_Month;
    
}

//MARK: - setMethod
- (void)setEventArray:(NSArray *)eventArray {
    _eventArray = eventArray;
}

- (void)setType:(CalendarType)type {
    
    if (_type == type) {
        
        NSString *currentDate = [[[NSString stringWithFormat:@"%@", [self dateForCellAtIndexPath:_selectIndex]] componentsSeparatedByString:@" "][0] componentsSeparatedByString:@"-"][1];
        if ([_dateMonth isEqualToString:currentDate]) {
            self.isAllowDrawCircle = NO;
        }else{
            _dateMonth = currentDate;
            self.isAllowDrawCircle = YES;
        }
    }else{
        
        NSString *currentDate = [[[NSString stringWithFormat:@"%@", [self dateForCellAtIndexPath:_selectIndex]] componentsSeparatedByString:@" "][0] componentsSeparatedByString:@"-"][1];
        if ([_dateMonth isEqualToString:currentDate]) {
            self.isAllowDrawCircle = NO;
        }else{
            _dateMonth = currentDate;
            self.isAllowDrawCircle = YES;
        }
        
    }
    
    [_collectionV reloadData];
    _type = type;
}
//MARK: - dateMethod
//获取cell的日期 (日 -> 六   格式,如需修改星期排序只需修改该函数即可)
- (NSDate *)dateForCellAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_type == CalendarType_Month) {
        NSCalendar *myCalendar = [NSCalendar currentCalendar];
        NSDate *firstOfMonth = [[YXDateHelpObject manager] GetFirstDayOfMonth:_currentDate];
        NSInteger ordinalityOfFirstDay = [myCalendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfMonth forDate:firstOfMonth];
        NSDateComponents *dateComponents = [NSDateComponents new];
        dateComponents.day = (1 - ordinalityOfFirstDay) + indexPath.item;
        return [myCalendar dateByAddingComponents:dateComponents toDate:firstOfMonth options:0];
    } else {
        return [[YXDateHelpObject manager] getEarlyOrLaterDate:_currentDate LeadTime:indexPath.row - 6 Type:2];
    }
}

//MARK: - collectionViewDatasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_type == CalendarType_Week) {
        return 7;
    } else {
        return [[YXDateHelpObject manager] getRows:_currentDate] * 7;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YXDayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YXDayCell" forIndexPath:indexPath];
    NSDate *cellDate = [self dateForCellAtIndexPath:indexPath];
    cell.selectDate = _selectDate;
    cell.currentDate = _currentDate;
    cell.type = _type;
    cell.cellDate = cellDate;
    cell.investArr = self.investArr;
    cell.incomeArr = self.incomeArr;
    cell.mixArr = self.mixArr;
    //cell.circleView.hidden = YES;

    //if (self.isAllowDrawCircle) {
        
        if (self.investArr.count || self.incomeArr.count || self.mixArr.count) {
            
            //if (self.isAllowDrawCircle) {
            //cell.userInteractionEnabled = YES;
            
            [cell drawCircle];
            //}
            
        }else{
            
            //cell.userInteractionEnabled = NO;
            
            cell.circleView.hidden = YES;
        }
    //}
//    else{
//        
//        [cell showCircle];
//        
//    }
    
    return cell;
}
//MARK: - collectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    _selectIndex = indexPath;
    
    _selectDate = [self dateForCellAtIndexPath:indexPath];
    
    if (_sendSelectDate) {
        _sendSelectDate(_selectDate);
    }
}
/**
 *  获取当月日历
 */
- (void)getData:(NSString *)dateStr andCircleDate:(NSString *)circleStr year:(NSInteger)year month:(NSInteger)month{

    [DownLoadData postCalendar:^(id obj, NSError *error) {
        //获取有回款和投资记录的数据
        self.dataSource = obj[@"data"];
        //获取该月的最大天数
        self.monthMaxDay = [obj[@"monthMaxDay"] integerValue];
        
        //该数组中有该月的所有日期
        [self.allArr removeAllObjects];
        
        for (int i = 0; i < self.monthMaxDay; i++) {
            if (i < 9) {
                [self.allArr addObject:[NSString stringWithFormat:@"%@0%d", circleStr, i+1]];
            }else{
                [self.allArr addObject:[NSString stringWithFormat:@"%@%d", circleStr, i+1]];
            }
        }
        //在请求的所有有回款和投资的日历数组中进行分三类
        [self filterEventArray];
        
    } userId:[HCJFNSUser stringForKey:@"userId"] dateStr:dateStr];
}
/**
 *  在请求的所有有回款和投资的日历数组中进行分三类  只有投资 只有回款 当日投资和回款都有
 */
- (void)filterEventArray{
    
    [self.investArr removeAllObjects];
    [self.incomeArr removeAllObjects];
    [self.mixArr removeAllObjects];
    
    //该年月的所有日期
    for (int i = 0; i < self.monthMaxDay; i++) {
        //用当前年月日当做键来取值
        NSString *key = self.allArr[i];
        //用键取值
        NSString *event = self.dataSource[key];
        
        //假如拿到的值不为空 做进一步判断
        if (event) {
            //先获取只有投资的
            if ([event containsString:@"INVEST"] && ![event containsString:@"COLLECT"]) {
                [self.investArr addObject:key];
            }
            //在获取只有回款的
            else if ([event containsString:@"COLLECT"] && ![event containsString:@"INVEST"]){
                [self.incomeArr addObject:key];
            }
            //当日投资和回款都有
            else if([event containsString:@"COLLECT"] && [event containsString:@"INVEST"]){
                [self.mixArr addObject:key];
            }
        }
        //整个for循环完成  刷新数据
        if (i == self.monthMaxDay-1) {
            
            self.isAllowDrawCircle = YES;
            
            [_collectionV reloadData];
            
        }
    }
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
