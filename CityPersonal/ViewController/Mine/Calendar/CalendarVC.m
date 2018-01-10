//
//  CalendarVC.m
//  CityJinFu
//
//  Created by xxlc on 16/9/18.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "CalendarVC.h"
#import "MyBillRecordVC.h"
#import "YXCalendarView.h"
#import "AlterView.h"
#import "CalendarCell.h"
#import "MyBillRecordVC.h"

@interface CalendarVC ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) YXCalendarView *calendar;

@property (nonatomic, strong) UITableView *tableView;
//获取投资日历的高度
@property (nonatomic, assign) CGFloat calendarHeight;
//每次用户拖动tableView的时候，只能发送一次让tableView的header收起和展开的通知
@property (nonatomic, assign) BOOL isAllowPostNoti;

@property (nonatomic, strong) UILabel *investLabel;//投资金额标签
@property (nonatomic, strong) UILabel *incomeLabel;//回款金额标签

@property (nonatomic, strong) AlterView *alterView;//显示符号 和文字的自定义View
//可变数组  日历的投资回款记录
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) UIView *line;//单线

@property (nonatomic, strong) UIImageView *backgroundImage;//暂无数据背景图

@property (nonatomic, strong) NSString *tableViewIsHigh;//tableView是否压缩

@end

@implementation CalendarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //标题
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"投资日历"];
    //导航设置
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = navigationColor;
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];//左边的按钮
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    
    self.view.backgroundColor = backGroundColor;
    //加载投资日历
    [self.view addSubview:self.calendar];
    //获得上个月 和 下个月 按钮
    [self getTwoButton];
    //加载每日日历内容
    [self.view addSubview:self.tableView];
    //暂无数据背景图
    [self.tableView addSubview:self.backgroundImage];
    [self.backgroundImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(244*m6Scale, 244*m6Scale));
        make.centerX.mas_equalTo(self.tableView.mas_centerX);
        make.centerY.mas_equalTo(self.tableView.mas_centerY).offset(3*98*m6Scale/2);
    }];
    
    self.tableView.frame = CGRectMake(0, self.calendarHeight+20*m6Scale, kScreenWidth, kScreenHeight-self.calendarHeight-20*m6Scale-NavigationBarHeight);
    
    self.isAllowPostNoti = YES;
    
    [self serviceDataByData:self.calendar.dayStr];
    
    self.tableViewIsHigh = @"1";
}
/**
 *  获得上个月 和 下个月 按钮
 */
- (void)getTwoButton{
    //创建 上个月 下个月按钮
    for (int i = 0; i < 2; i++) {
        UIButton *button = [UIButton buttonWithType:0];
        button.tag = 100+i;
        button.userInteractionEnabled = YES;
        
        [button addTarget:self action:@selector(changeCalendarContent:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.calendar.yearMonthL.mas_centerY);
            if (i) {
                make.right.mas_equalTo(-10*m6Scale);
            }else{
                make.left.mas_equalTo(10*m6Scale);
            }
            make.size.mas_equalTo(CGSizeMake(100*m6Scale, 100*m6Scale));
        }];
    }
}
/**
 *  上个月  和下个月 按钮的点击事件
 */
- (void)changeCalendarContent:(UIButton *)sender{
    //发送通知  显示上个月 或者 下个月 日历的相关内容
    NSNotification *noti = [[NSNotification alloc] initWithName:@"slipToMonth" object:nil userInfo:@{@"tag":[NSString stringWithFormat:@"%ld", sender.tag]}];
    
    [[NSNotificationCenter defaultCenter] postNotification:noti];
}
/**
 *  单线
 */
- (UIView *)line{
    if(!_line){
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, 98*m6Scale-1, kScreenWidth, 1)];
        _line.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.3];
    }
    return _line;
}
/**
 *  tableView的懒加载
 */
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] init];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.userInteractionEnabled = YES;
        //去掉分割线
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = backGroundColor;
    }
    return _tableView;
}
/**
 *  日历的懒加载
 */
- (YXCalendarView *)calendar{
    if(!_calendar){
        _calendar = [[YXCalendarView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [YXCalendarView getMonthTotalHeight:[NSDate date] type:CalendarType_Month]) Date:[NSDate date] Type:CalendarType_Month];
        self.calendarHeight = [YXCalendarView getMonthTotalHeight:[NSDate date] type:CalendarType_Month];
        __weak typeof (self) WeakSelf = self;
        //改变日历头部和tableView 的cell位置
        [self changeLocation];
        //点击日历某一个日期  进行数据刷新
        _calendar.sendSelectDate = ^(NSDate *selDate) {
            [WeakSelf serviceDataByData:[[YXDateHelpObject manager] getStrFromDateFormat:@"yyyy-MM-dd" Date:selDate]];
        };
    }
    return _calendar;
}
/**
 *  投资金额标签
 */
- (UILabel *)investLabel{
    if(!_investLabel){
        _investLabel = [self createCommonLabel];
    }
    return _investLabel;
}
/**
 *  回款金额标签
 */
- (UILabel *)incomeLabel{
    if(!_incomeLabel){
        _incomeLabel = [self createCommonLabel];
    }
    return _incomeLabel;
}
/**
 *  显示符号 和文字的自定义View
 */
- (UIView *)alterView{
    if(!_alterView){
        _alterView = [[AlterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 98*m6Scale)];
        _alterView.backgroundColor = backGroundColor;
    }
    return _alterView;
}
/**
 *  公用Label
 */
- (UILabel *)createCommonLabel{
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:30*m6Scale];
    label.textColor = UIColorFromRGB(0xff5933);
    label.text = @"0";
    
    return label;
}
/**
 *  可变数组  日历的投资回款记录
 */
- (NSMutableArray *)dataSource{
    if(!_dataSource){
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
/**
 *  获取当日投资和回款记录
 */
- (void)serviceDataByData:(NSString *)data{
    [DownLoadData postCalendarList:^(id obj, NSError *error) {
        //当日投资总额
        self.investLabel.text = [NSString stringWithFormat:@"%d元", [obj[@"investTotal"] intValue]];
        [Factory ChangeColorString:@"元" andLabel:self.investLabel andColor:UIColorFromRGB(0x9b9b9b)];
        //当日回款记录
        self.incomeLabel.text = [NSString stringWithFormat:@"%d元", [obj[@"repayTotal"] intValue]];
        [Factory ChangeColorString:@"元" andLabel:self.incomeLabel andColor:UIColorFromRGB(0x9b9b9b)];
        //回款和投资记录
        self.dataSource = obj[@"dataSource"];
        
        if (self.dataSource.count) {
            
            self.backgroundImage.hidden = YES;
            
        }else{
            
            self.backgroundImage.hidden = NO;
            
        }
        
        [self.tableView reloadData];
        
    } userId:[HCJFNSUser stringForKey:@"userId"] viewDate:data];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3+self.dataSource.count;
}
/**
 *  改变日历头部和tableView 的cell位置
 */
- (void)changeLocation{
    __weak typeof(_calendar) weakCalendar = _calendar;
    __weak typeof (self) WeakSelf = self;

    _calendar.refreshH = ^(CGFloat viewH) {
        WeakSelf.calendarHeight = viewH;
        [UIView animateWithDuration:0.3 animations:^{
            weakCalendar.frame = CGRectMake(0, 0, kScreenWidth, viewH);
            
            WeakSelf.tableView.frame = CGRectMake(0, viewH+20*m6Scale, [UIScreen mainScreen].bounds.size.width, kScreenHeight-viewH-20*m6Scale-NavigationBarHeight);
        }];
    };
}
/**
 *  通过监听tableViewcell的偏移量 从而判断tableView的头部应该收缩或者伸展
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y > 0) {
        //标题
        [TitleLabelStyle addtitleViewToVC:self withTitle:self.calendar.dataStr];
        NSNotification *notifi = [[NSNotification alloc] initWithName:@"changeHeaderHeightToLow" object:nil userInfo:@{@"tableViewIsHigh":@"1"}];
        [[NSNotificationCenter defaultCenter] postNotification:notifi];
        
        if (self.dataSource.count) {
            
            self.backgroundImage.hidden = YES;
            
        }else{
            
            self.backgroundImage.hidden = NO;
            
        }
        
        
    }else if(scrollView.contentOffset.y < 0){
        //标题
        [TitleLabelStyle addtitleViewToVC:self withTitle:@"投资日历"];
        NSNotification *notifi = [[NSNotification alloc] initWithName:@"changeHeaderHeightToHeigh" object:nil userInfo:@{@"tableViewIsHigh":@"1"}];
        [[NSNotificationCenter defaultCenter] postNotification:notifi];

        if (self.dataSource.count) {
            
            self.backgroundImage.hidden = YES;
            
        }else{
            
            self.backgroundImage.hidden = NO;
            
        }
    }
}


#pragma mark - cellForRowAtIndexPath
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < 3) {
        NSString *str = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
        }
        cell.selectionStyle = NO;
        NSArray *textArr = @[@"当日投资总额", @"当日回款总额"];
        if (indexPath.row < 2) {
            
            if (indexPath.row == 0) {
                [cell addSubview:self.line];
            }
            cell.textLabel.text = textArr[indexPath.row];
            cell.textLabel.font = [UIFont systemFontOfSize:30*m6Scale];
            cell.textLabel.textColor = UIColorFromRGB(0x373737);
            
            if (indexPath.row) {
                [self layoutLabel:self.incomeLabel andSubView:cell.contentView];
            }else{
                [self layoutLabel:self.investLabel andSubView:cell.contentView];
            }
        }else{
            [cell.contentView addSubview:self.alterView];
        }
        
        return cell;
    }
    else{
        NSString *str = @"CalendarCell";
        CalendarCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[CalendarCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
        }
        
        [cell cellForModel:self.dataSource[indexPath.row-3]];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row > 2) {
        
        //跳转至投资记录页面
        MyBillRecordVC *tempVC = [[MyBillRecordVC alloc] init];
        
        CalendarListModel *model = self.dataSource[indexPath.row-3];
        if ([model.type isEqualToString:@"投资"]) {
            tempVC.investID = [NSString stringWithFormat:@"%@", model.investId                                                  ];
            tempVC.section = 2;
        }else{
            tempVC.investID = [NSString stringWithFormat:@"%@", model.collectId                                                  ];
            tempVC.section = 3;
        }
        
        [self.navigationController pushViewController:tempVC animated:YES];
    }
    
}
/**
 *暂无数据背景图片
 */
- (UIView *)backgroundImage{
    if(!_backgroundImage){
        _backgroundImage = [[UIImageView alloc]init];
        _backgroundImage.image = [UIImage imageNamed:@"无数据"];
        _backgroundImage.hidden = YES;
    }
    return _backgroundImage;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < 3) {
        return 98*m6Scale;
    }else{
        return 214*m6Scale;
    }
}
/**
 * 约束投资金额和回款金额的标签位置
 */
- (void)layoutLabel:(UILabel *)label andSubView:(UIView *)subView{
    [subView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20*m6Scale);
        make.centerY.mas_equalTo(subView.mas_centerY);
    }];
}
/**
 *  个人中心
 */
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [Factory hidentabar];//隐藏tabar
    [Factory navgation:self];//导航的处理
}

@end
