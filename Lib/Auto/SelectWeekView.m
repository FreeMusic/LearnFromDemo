//
//  SelectWeekView.m
//  ysyy_pat
//
//  Created by apple on 2016/10/11.
//  Copyright © 2016年 张博. All rights reserved.
//

#import "SelectWeekView.h"

@interface SelectWeekView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray *dataArray;//总的数组
@property (nonatomic, strong) NSMutableArray *monthArray;//月的数组
@property (nonatomic, strong) NSMutableArray *rateArray;//利率的数组
@property (nonatomic, strong) NSMutableArray *muMonth;//月

@end

@implementation SelectWeekView

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}
/**
 月的数组
 */
- (NSMutableArray *)monthArray{
    if (!_monthArray) {
        _monthArray = [NSMutableArray array];
    }
    return _monthArray;
}
/**
 rateArray
 */
- (NSMutableArray *)rateArray{
    if (!_rateArray) {
        _rateArray = [NSMutableArray array];
    }
    return _rateArray;
}
/**
 月
 */
- (NSMutableArray *)muMonth{
    if (!_muMonth) {
        _muMonth = [NSMutableArray array];
    }
    return _muMonth;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        _date = [NSDate date];
        self.dataArray = [self getWeek];
        
        [self setUI];
        
    }
    return self;
}

#pragma mark - 获取周
- (NSArray *)getWeek  {
    NSMutableArray *dataArr = [NSMutableArray array];
    NSMutableArray *muArr = [NSMutableArray array];
    NSString *str1 = @"";
    for (int i = 3; i < 13; i++) {
        for (int j = 1; j < 11; j++) {
            
            str1 = [NSString stringWithFormat:@"%.1f%%",10 + j * 0.2];
            NSLog(@"888----%.1f",str1.doubleValue);
            [muArr addObject:str1];
            [self.rateArray addObject:[NSString stringWithFormat:@"%.1f",str1.doubleValue]];
        }
        NSString *str = [NSString stringWithFormat:@"%d个月",i];
        NSString *str3 = [NSString stringWithFormat:@"%@  ——  %@",str,muArr[i-3]];
        [self.monthArray addObject:[NSString stringWithFormat:@"%d",str.intValue*30]];
        [self.muMonth addObject:[NSString stringWithFormat:@"%d",str.intValue]];
        [dataArr addObject:str3];
//        NSString *str = [NSString stringWithFormat:@"%d个月",i];
        
        
//        NSCalendar *calendar = [NSCalendar currentCalendar];
//        NSDateComponents *comp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitDay
//                                             fromDate:_date];
//        // 得到星期几
//        // 1(星期一) 2(星期二) 3(星期三) 4(星期四) 5(星期五) 6(星期六) 7(星期天)
//        NSInteger weekDay = [comp weekday];
//        // 得到几号
//        NSInteger day = [comp day];
//        
////        NSInteger month = [comp month];
//        
////        NSLog(@"weekDay:%ld   day:%ld  month : %ld",weekDay,day, month);
//        
//        // 计算当前日期和这周的星期一和星期天差的天数
//        long firstDiff,lastDiff;
//        if (weekDay == 1) {
//            firstDiff = 0;
//            lastDiff = 7;
//        }else{
//            firstDiff = [calendar firstWeekday] - weekDay  + 1;
//            lastDiff = 8 - weekDay;
//        }
//        
////        NSLog(@"firstDiff:%ld   lastDiff:%ld",firstDiff,lastDiff);
//        
//        // 在当前日期(去掉了时分秒)基础上加上差的天数
//        NSDateComponents *firstDayComp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:_date];
//        [firstDayComp setDay:day + firstDiff];
//        NSDate *firstDayOfWeek= [calendar dateFromComponents:firstDayComp];
//        
//        NSDateComponents *lastDayComp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:_date];
//        [lastDayComp setDay:day + lastDiff];
//        NSDate *lastDayOfWeek= [calendar dateFromComponents:lastDayComp];
//        
//        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
//        [formater setDateFormat:@"yyyy-MM-dd"];
//        
//        NSString *str1 = [formater stringFromDate:firstDayOfWeek];
//        NSString *str2 = [formater stringFromDate:lastDayOfWeek];
//        
//        //        NSLog(@"星期一开始 %@",str1);
//        //    NSLog(@"当前 %@",[formater stringFromDate:_date]);
//        //        NSLog(@"星期天结束 %@",str2);
//        
//        NSString *weekStr = [NSString stringWithFormat:@"%@   ——   %@",str1,str2];
//        
//        [dataArr addObject:weekStr];
//        
//        NSDateComponents *tempComp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:_date];
//        [tempComp setDay:day - 7];
//        NSDate  *tempDate =  [calendar dateFromComponents:tempComp];
//        
//        //        _date = nil;
//        _date = tempDate;
    }

    return dataArr;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"ghdklhdfkdfgjk");
    
}

#pragma mark - 布局
- (void)setUI {
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
//    UITapGestureRecognizer * singleRecognizer =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelButtonClick:)];//手势
//    singleRecognizer.numberOfTapsRequired = 1;
//    [backView addGestureRecognizer:singleRecognizer];
//    backView.userInteractionEnabled = NO;
    [self addSubview:backView];
    
    UIView *topBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    topBgView.backgroundColor = ButtonColor;
    [self addSubview:topBgView];
    //取消
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitleColor:[UIColor whiteColor]
 forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [cancelBtn addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [topBgView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topBgView.mas_right).offset(-30*m6Scale);
        make.centerY.equalTo(topBgView.mas_centerY);
        make.height.mas_equalTo(@(60*m6Scale));
    }];
    //选择时间和利率
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:30*m6Scale];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"选择时间和利率";
    label.textColor =  [UIColor whiteColor];
    [topBgView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topBgView.mas_centerX);
        make.centerY.equalTo(topBgView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(300*m6Scale, 60*m6Scale));
    }];
    //tableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, self.bounds.size.height - 40) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight  = 50;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self addSubview:tableView];
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *tempStr = self.muMonth[indexPath.row];
    NSLog(@"444---%@=======555---%@",_monthArray[indexPath.row],_rateArray[indexPath.row] );
    self.selectBlock(tempStr,[NSString stringWithFormat:@"%@",_monthArray[indexPath.row]],[NSString stringWithFormat:@"%@",_rateArray[indexPath.row]]);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RATE" object:nil];
    [self dismiss];
}

#pragma mark - 显示/消失
- (void)show {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
    //动画效果
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.alpha = 1;
    }];
    
}

- (void)dismiss {
    
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
   
//    [self removeFromSuperview];
}

//- (void)cancelButtonClick:(UITapGestureRecognizer *)sender{
//    [self dismiss];
//}
#pragma mark - 取消按钮点击
- (void)cancelButtonClick {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RATE" object:nil];
    [self dismiss];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}


@end
