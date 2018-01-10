//
//  NewMyBillVC.m
//  CityJinFu
//
//  Created by mic on 2017/10/17.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "NewMyBillVC.h"
#import "NewMyBillCell.h"
#import "BillFilterView.h"

@interface NewMyBillVC ()<UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UIView *backView;//头图黄色背景图

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UILabel *rechargeLabel;//充值总额

@property (nonatomic, strong) UILabel *withLabel;//提现总额

@property (nonatomic, strong) UILabel *investLabel;//投资总额

@property (nonatomic, strong) UILabel *incomeLabel;//回款总额

@property (nonatomic, strong) UILabel *monthLabel;//月份账单筛选

@property (nonatomic, strong) BillFilterView *filterView;//筛选页面

@property (nonatomic, strong) UIView *whiteView;//白色背景View

@property (nonatomic, strong) UILabel *filterLabel;//筛选按钮

@property (nonatomic, strong) NSMutableArray *dataSource;//交易记录数据源

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) NSString *type;//筛选类型

@property (nonatomic, strong) UIImageView *backgroundImage;//暂无数据背景那个图

@property (nonatomic, assign) NSInteger monthComponent;

@end

@implementation NewMyBillVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = backGroundColor;
    self.type = @"10000";
    [self.view addSubview:self.tableView];
    //暂无数据背景图
    [self.tableView addSubview:self.backgroundImage];
    [self.backgroundImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(244*m6Scale, 244*m6Scale));
        make.centerX.mas_equalTo(self.tableView.mas_centerX);
        make.centerY.mas_equalTo(self.tableView.mas_centerY).offset(3*98*m6Scale/2);
    }];
    //创建日期选择器
    [self CreateDataPickerView];
    //账单顶部视图
    [self myBillTopView];
}
/**
 *tableView的懒加载
 */
- (UITableView *)tableView{
    if(!_tableView){
        if (iOS11) {
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 316*m6Scale, kScreenWidth, kScreenHeight-316*m6Scale)];
        }else{
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 316*m6Scale-NavigationBarHeight, kScreenWidth, kScreenHeight-316*m6Scale+NavigationBarHeight)];
        }
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    return _tableView;
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
/**
 *  头图黄色背景图
 */
- (UIView *)backView{
    if(!_backView){
        //黄色大背景
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 316*m6Scale)];
        _backView.backgroundColor = navigationYellowColor;
        [self.navigationController.view addSubview:_backView];
    }
    return _backView;
}
/**
 *充值总额
 */
- (UILabel *)rechargeLabel{
    if(!_rechargeLabel){
        _rechargeLabel = [self commonLabel];
    }
    return _rechargeLabel;
}
/**
 *提现总额
 */
- (UILabel *)withLabel{
    if(!_withLabel){
        _withLabel = [self commonLabel];
    }
    return _withLabel;
}
/**
 *投资总额
 */
- (UILabel *)investLabel{
    if(!_investLabel){
        _investLabel = [self commonLabel];
    }
    return _investLabel;
}
/**
 *回款总额
 */
- (UILabel *)incomeLabel{
    if(!_incomeLabel){
        _incomeLabel = [self commonLabel];
    }
    return _incomeLabel;
}
/**
 *  交易记录数据源
 */
- (NSMutableArray *)dataSource{
    if(!_dataSource){
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (UILabel *)commonLabel{
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = UIColorFromRGB(0x393939);
    label.font = [UIFont systemFontOfSize:30*m6Scale];
    label.text = @"100.00";
    
    return label;
}

/**
 * 返回
 */
- (void)leftBtn:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
/**
 *  账单顶部视图
 */
- (void)myBillTopView{
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:0];
    [backBtn setImage:[UIImage imageNamed:@"Back-Arrow"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(leftBtn:) forControlEvents:UIControlEventTouchUpInside];
    if (kStatusBarHeight > 20) {
        backBtn.frame = CGRectMake(15*m6Scale, 70*m6Scale, 70*m6Scale, 70*m6Scale);
    }else{
        backBtn.frame = CGRectMake(15*m6Scale, 40*m6Scale, 70*m6Scale, 70*m6Scale);
    }
    [self.backView addSubview:backBtn];
    
    //小头像
    UIImageView *headImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NewMyBill_我的"]];
    [self.backView addSubview:headImgView];
    [headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(81*m6Scale, 81*m6Scale));
        make.centerX.mas_equalTo(self.backView.mas_centerX);
        make.centerY.mas_equalTo(self.backView.mas_centerY);
    }];
    
    UIView *backView = [[UIView alloc] init];
    [self.backView addSubview:backView];
    
    //月份账单筛选
    _monthLabel = [UILabel labelWithTextColor:UIColorFromRGB(0xffffff) andTextFont:30 andText:[NSString stringWithFormat:@"%@账单",  self.nowDateStr] addSubView:backView tapBlock:^(UILabel *lable) {
        self.firstTime = NO;
        self.dateBackView.hidden = NO;
    }];
    [_monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    //筛选箭头
    UIImageView *imageView = [UIImageView image:[UIImage imageNamed:@"NewMyBill_下拉"] subView:backView tapBlock:^(UIImageView *imageView) {
        self.firstTime = NO;
        self.dateBackView.hidden = NO;
    }];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_monthLabel.mas_right).offset(10*m6Scale);
        make.bottom.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(35*m6Scale, 35*m6Scale));
    }];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_monthLabel.mas_left);
        make.right.mas_equalTo(imageView.mas_right);
        make.centerX.mas_equalTo(self.backView.mas_centerX);
        make.bottom.mas_equalTo(-48*m6Scale);
        make.height.mas_equalTo(50*m6Scale);
    }];
    
    //筛选按钮
    self.filterLabel.frame = CGRectMake(kScreenWidth-100*m6Scale, 40*m6Scale, 70*m6Scale, 70*m6Scale);
}
/**
 *  筛选按钮
 */
- (UILabel *)filterLabel{
    if(!_filterLabel){
        _filterLabel = [UILabel labelWithTextColor:[UIColor whiteColor] andTextFont:28 andText:@"筛选" addSubView:self.backView tapBlock:^(UILabel *label) {
            [self filterAction];
        }];
        _filterLabel.hidden = YES;
    }
    return _filterLabel;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count+1;
}
#pragma mark - cellForRowAtIndexPath
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        NSString *str = @"cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
            _topView = [self getTableHeaderView];
        }
        cell.selectionStyle = NO;
        [cell addSubview:_topView];
        [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.mas_equalTo(0);
        }];
        
        return cell;
    }else{
        NSString *str = @"NewMyBillCell";
        
        NewMyBillCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        
        if (!cell) {
            
            cell = [[NewMyBillCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
            
        }
        
        [cell cellForModel:self.dataSource[indexPath.row-1]];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return 530*m6Scale;
    }else{
        return 162*m6Scale;
    }
}

- (UIView *)getTableHeaderView{
    
    UIView *headerView = [[UIView alloc] init];
    //月账单
    UILabel *monthBillLabel = [Factory CreateLabelWithColor:UIColorFromRGB(0x393939) andTextFont:30 andText:@"月账单" addSubView:headerView];
    [monthBillLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20*m6Scale);
        make.top.mas_equalTo(27*m6Scale);
    }];
    
    //单线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 84*m6Scale, kScreenWidth, 1)];
    line.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.3];
    [headerView addSubview:line];
    
    NSArray *array = @[@"充值总额", @"提现总额", @"投资总额", @"回款总额"];
    
    //总额
    for (int i = 0 ; i < array.count; i++) {
        
        UILabel *leftLabel = [Factory CreateLabelWithColor:UIColorFromRGB(0x393939) andTextFont:30 andText:array[i] addSubView:headerView];
        [headerView addSubview:leftLabel];
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20*m6Scale);
            make.top.mas_equalTo(i*72*m6Scale+44*m6Scale+84*m6Scale);
        }];
    }
    //充值总额
    [self layoutLabel:self.rechargeLabel location:0 addSubView:headerView];
    //提现总额
    [self layoutLabel:self.withLabel location:1 addSubView:headerView];
    //投资总额
    [self layoutLabel:self.investLabel location:2 addSubView:headerView];
    //回款总额
    [self layoutLabel:self.incomeLabel location:3 addSubView:headerView];
    
    //灰色背景View
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 420*m6Scale, kScreenWidth, 30*m6Scale)];
    backView.backgroundColor = backGroundColor;
    [headerView addSubview:backView];
    //交易记录标签
    UILabel *recordLabel = [Factory CreateLabelWithColor:UIColorFromRGB(0x393939) andTextFont:30 andText:@"交易记录" addSubView:headerView];
    [recordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20*m6Scale);
        make.bottom.mas_equalTo(-27*m6Scale);
    }];
    //筛选按钮
    UILabel *filterLab = [UILabel labelWithTextColor:UIColorFromRGB(0x393939) andTextFont:28 andText:@"筛选" addSubView:headerView tapBlock:^(UILabel *label) {
        [self filterAction];
    }];
    [filterLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20*m6Scale);
        make.bottom.mas_equalTo(-18*m6Scale);
        make.size.mas_equalTo(CGSizeMake(80*m6Scale, 45*m6Scale));
    }];
    //单线
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 530*m6Scale-1, kScreenWidth, 1)];
    line1.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.3];
    [headerView addSubview:line1];
    
    return headerView;
}
/**
 *  筛选按钮点击事件
 */
- (void)filterAction{
    
    if (!_filterView) {
        
        _filterView = [[BillFilterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _filterView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.3];
        [self.navigationController.view addSubview:_filterView];
        
        //白色背景View
        _whiteView = [[UIView alloc] init];
        _whiteView.backgroundColor = [UIColor whiteColor];
        [_filterView addSubview:_whiteView];
        [_whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(362*m6Scale);
        }];
        
        //按类型筛选标签
        UILabel *typeLabel = [Factory CreateLabelWithColor:UIColorFromRGB(0x393939) andTextFont:28 andText:@"按类型筛选" addSubView:_whiteView];
        [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20*m6Scale);
            make.top.mas_equalTo(44*m6Scale);
        }];
        
        NSArray *array = @[@"全部", @"投资", @"回款", @"充值", @"提现", @"其他"];
        
        for (int i = 0; i < array.count; i++) {
            
            UIButton *btn = [UIButton buttonWithType:0];
            [btn addTarget:self action:@selector(typeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 1000+i;
            [btn setTitle:array[i] forState:0];
            [btn setTitleColor:UIColorFromRGB(0x525151) forState:0];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:28*m6Scale];
            btn.layer.cornerRadius = 5*m6Scale;
            
            btn.backgroundColor = (i == 0) ? (navigationYellowColor) : ([UIColor colorWithWhite:0.7 alpha:0.3]);
            btn.selected = (i == 0) ? YES : NO;
            [_whiteView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(130*m6Scale, 60*m6Scale));
                make.top.mas_equalTo(typeLabel.mas_bottom).offset((i/4)*92*m6Scale + 44*m6Scale);
                make.left.mas_equalTo((i%4)*162*m6Scale+20*m6Scale);
            }];
        }
    }
    
    _filterView.hidden = NO;
}
/**
 *  类型按钮点击事件
 */
- (void)typeButtonClick:(UIButton *)sender{
    
    for (int i = 1000; i < 1006; i++) {
        
        UIButton *button = (UIButton *)[_whiteView viewWithTag:i];
        
        button.selected = (i == sender.tag) ? YES : NO;
        button.backgroundColor = (i == sender.tag) ? (navigationYellowColor) : ([UIColor colorWithWhite:0.7 alpha:0.3]);
    }
    
    switch (sender.tag) {
        case 1000:
            self.type = @"10000";
            break;
        case 1001:
            self.type = @"1";
            break;
        case 1002:
            self.type = @"2";
            break;
        case 1003:
            self.type = @"3";
            break;
        case 1004:
            self.type = @"4";
            break;
        case 1005:
            self.type = @"5";
            break;
            
        default:
            self.type = @"10000";
            break;
    }
    [DownLoadData postGetAccountLog:^(id obj, NSError *error) {
        
        [self.dataSource removeAllObjects];
        
        self.dataSource  = obj;
        
        if (self.dataSource.count) {
            
            self.backgroundImage.hidden = YES;
            
        }else{
            
            self.backgroundImage.hidden = NO;
            
        }
        
        [self.tableView reloadData];
        
    } userId:[HCJFNSUser stringForKey:@"userId"] queryMonth:self.result type:self.type];
    
    _filterView.hidden = YES;
    
}
- (void)layoutLabel:(UILabel *)label location:(NSInteger)location addSubView:(UIView *)subView{
    
    [subView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20*m6Scale);
        make.top.mas_equalTo(location*72*m6Scale+44*m6Scale+84*m6Scale);
    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [Factory hidentabar];
    //修改电池电量条的颜色为白色
    UIApplication *myApplication = [UIApplication sharedApplication];
    
    [myApplication setStatusBarHidden:NO];
    
    [myApplication setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    self.backView.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    self.backView.hidden = YES;
}

/**
 *   时间选择器的创建
 */
- (void)CreateDataPickerView{
    //获取当前时间
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY年MM月"];
    self.nowDateStr = [dateFormatter stringFromDate:currentDate];
    self.checkDate = [dateFormatter stringFromDate:currentDate];
    NSInteger year = [self.nowDateStr substringToIndex:4].integerValue;
    NSInteger month = [self.nowDateStr substringFromIndex:5].integerValue;
    
    //选择器年月数据
    self.componentOneArr = [NSMutableArray new];
    self.componentTwoArr = [NSMutableArray new];
    for (NSInteger i = 2015; i <= year; i++) {
        NSString *str = [NSString stringWithFormat:@"%ld年",(long)i];
        [self.componentOneArr addObject:str];
    }
    NSMutableArray *normalComponentTwoArr = [NSMutableArray new];
    for (int i = 1; i < 13; i ++) {
        NSString *str;
        if (i < 10) {
            str = [NSString stringWithFormat:@"0%d月", i];
        } else {
            str = [NSString stringWithFormat:@"%d月", i];
        }
        [normalComponentTwoArr addObject:str];
        [self.componentTwoArr addObject:normalComponentTwoArr];
        
    }
    
    NSMutableArray *lastComponentTwoArr = [NSMutableArray new];
    for (int i = 1; i <= month; i ++) {
        NSString *str;
        if (i < 10) {
            str = [NSString stringWithFormat:@"0%d月", i];
        } else {
            str = [NSString stringWithFormat:@"%d月", i];
        }
        [lastComponentTwoArr addObject:str];
        [self.componentTwoArr addObject:lastComponentTwoArr];
    }
    
    self.typeStr = nil;
    self.result1 = nil;
    self.result2 = nil;
    
    self.firstTime = YES;
    //创建日期选择界面
    [self createMaskView];
}
#pragma mark - 创建日期选择界面
//创建日期选择界面
- (void) createMaskView {
    //蒙板
    self.dateBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.dateBackView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.35];
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelChoose)];
    [self.dateBackView addGestureRecognizer:singleTap];
    self.dateBackView.hidden = YES;
    AppDelegate *dategate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [dategate.window addSubview:self.dateBackView];
    
    //选择日期黄底
    UIView *smallView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight * 0.67, kScreenWidth, 75 * m6Scale)];
    smallView.backgroundColor = ButtonColor;
    [self.dateBackView addSubview:smallView];
    
    //取消按钮
    UIButton *cancelBtn = [UIButton new];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:30 * m6Scale];
    [cancelBtn setTitle:@"取消" forState:0];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:0];
    [cancelBtn addTarget:self action:@selector(cancelChoose) forControlEvents:UIControlEventTouchUpInside];
    
    [smallView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(smallView.mas_left).offset(32 * m6Scale);
        make.centerY.equalTo(smallView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(120 * m6Scale, 72 * m6Scale));
    }];
    
    //确定按钮
    UIButton *sureBtn = [UIButton new];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:32 * m6Scale];
    [sureBtn setTitle:@"确定" forState:0];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:0];
    [sureBtn addTarget:self action:@selector(sureChoose:) forControlEvents:UIControlEventTouchUpInside];
    [smallView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(smallView.mas_right).offset(-30 * m6Scale);
        make.centerY.equalTo(smallView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(120 * m6Scale, 72 * m6Scale));
    }];
    
    //选择提示lab
    UILabel *signLab = [UILabel new];
    signLab.text = @"选择日期";
    signLab.font = [UIFont systemFontOfSize:32 * m6Scale];
    signLab.textColor = [UIColor whiteColor];
    [smallView addSubview:signLab];
    [signLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(smallView.mas_centerX);
        make.centerY.equalTo(smallView.mas_centerY);
    }];
    
    //日期选择器
    self.datePicker = [UIPickerView new];
    self.datePicker.backgroundColor = [UIColor whiteColor];
    self.datePicker.delegate = self;
    self.datePicker.dataSource = self;
    [self.dateBackView addSubview:self.datePicker];
    
    //默认选中
    if (self.firstTime) {
        [self.datePicker selectRow:(self.componentOneArr.count-1) inComponent:0 animated:YES];
        self.result1 = self.componentOneArr.lastObject;
        NSArray *arr = self.componentTwoArr.lastObject;
        [self.datePicker selectRow:(arr.count-1) inComponent:2 animated:YES];
        self.result2 = arr.lastObject;
    }
    
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backView.mas_centerX);
        make.top.equalTo(smallView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, kScreenHeight * 0.33 - 75 * m6Scale));
    }];
    self.result = [NSString stringWithFormat:@"%@%@", self.result1, self.result2];
    //请求数据
    [self getData];
}
/**
 *请求数据
 */
- (void)getData{
    
    [DownLoadData postGetAccountLog:^(id obj, NSError *error) {
        
        [self.dataSource removeAllObjects];
        
        self.dataSource  = obj;
        
        if (self.dataSource.count) {
            
            self.backgroundImage.hidden = YES;
            
        }else{
            
            self.backgroundImage.hidden = NO;
            
        }
        
        [self.tableView reloadData];
        
    } userId:[HCJFNSUser stringForKey:@"userId"] queryMonth:self.result type:self.type];
    //我的账单首页
    [DownLoadData postBillIndex:^(id obj, NSError *error) {
        
        self.rechargeLabel.text = [NSString stringWithFormat:@"%.2f", [obj[@"countRecharge"] doubleValue]];//充值总额
        self.withLabel.text = [NSString stringWithFormat:@"%.2f", [obj[@"countCash"] doubleValue]];//提现总额
        self.investLabel.text = [NSString stringWithFormat:@"%.2f", [obj[@"investTotal"] doubleValue]];//投资总额
        self.incomeLabel.text = [NSString stringWithFormat:@"%.2f(本金)+%.2f(利息)", [obj[@"collectTotal"] doubleValue], [obj[@"income"] doubleValue]];//回款总额
        
    } userId:[HCJFNSUser stringForKey:@"userId"] queryMonth:self.result];
}

/**
 *时间标签的点击
 */
- (void)AlsoJumpToCalendar
{
    self.firstTime = NO;
    self.dateBackView.hidden = NO;
}
#pragma mark - UIPickerViewDelegate and UIPickerViewDataSource
//选择器的列
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}
//选择器的行
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if (component == 0) {
        return self.componentOneArr.count;
    }
    else if (component == 2) {
        NSString *year = [self.nowDateStr substringToIndex:4];
        
        if ([self.result1 isEqualToString:[year stringByAppendingString:@"年"]]) {
            NSArray *arr =  self.componentTwoArr.lastObject;
            if (_monthComponent+1 > arr.count) {
                self.result2 =  arr.lastObject;
            }else{
                self.result2 = arr[_monthComponent];
            }
            return arr.count;
        }
        else {
            return 12;
        }
    } else {
        return 1;
    }
}
//选择器的高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 120 * m6PScale;
    
}
//选择器的title
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return self.componentOneArr[row];
    } else if (component == 2) {
        NSString *year = [self.nowDateStr substringToIndex:4];
        if ([self.result1 isEqualToString:[year stringByAppendingString:@"年"]]) {
            NSArray *arr =  self.componentTwoArr.lastObject;
            return  arr[row];
        }
        else {
            NSArray *arr =  self.componentTwoArr.firstObject;
            return arr[row];
        }
    } else {
        return @"～";
    }
}

//pickerView字体大小及样式
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setTextColor:[UIColor blackColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:32 * m6Scale]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

//选中年月
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"row = %ld   component = %ld", row, component);
    if (component == 0) {
        self.result1 = self.componentOneArr[row];
        [self.datePicker reloadComponent:2];
    }
    else if (component == 2) {
        _monthComponent = row;
        NSString *year = [self.nowDateStr substringToIndex:4];
        if ([self.result1 isEqualToString:[year stringByAppendingString:@"年"]]){
            NSArray *arr =  self.componentTwoArr.lastObject;
            self.result2 =  arr[row];
        }
        else{
            NSArray *arr =  self.componentTwoArr.firstObject;
            self.result2 = arr[row];
        }
    }
}
//日期选择确按钮
- (void)sureChoose:(UIButton *)sender {
    //年月不同的时候 清空数组 并请求数据
    if ([self.result isEqualToString:[NSString stringWithFormat:@"%@%@", self.result1, self.result2]]) {
        NSLog(@"");
    }else{
        [self.investArr removeAllObjects];
        [self.incomeArr  removeAllObjects];
        self.result = [NSString stringWithFormat:@"%@%@", self.result1, self.result2];
        
        _monthLabel.text = [NSString stringWithFormat:@"%@%@账单", self.result1, self.result2];
        //请求数据
        [self getData];
    }
    //移除日期选择界面
    self.dateBackView.hidden = YES ;
    //筛选类型置nil
    self.typeStr = nil;
}

//日期选择取消按钮
- (void)cancelChoose{
    self.dateBackView.hidden = YES;;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSLog(@"%f", scrollView.contentOffset.y);
    
    if (scrollView.contentOffset.y >530*m6Scale-NavigationBarHeight) {
        
        _filterLabel.hidden = NO;
        
    }else{
        
        _filterLabel.hidden = YES;
        
    }
}

@end
