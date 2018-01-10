//
//  MyBillVC.m
//  CityJinFu
//
//  Created by xxlc on 17/5/25.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "MyBillVC.h"
#import "MyBillHeaderCell.h"
#import "MyBillSecondCell.h"
#import "MyBillDetailCell.h"
#import "MyBillRecordVC.h"
#import "BillAcountModel.h"
#import "BillIndexModel.h"
#import "CurrentBillRecordVC.h"
#import "BillDataModel.h"
#import "PartIncomeModel.h"
#import "PartInvestModel.h"

#define DIC_EXPANDED @"expanded" //是否是展开 0收缩 1展开
#define DIC_ARARRY @"array" //存放数组
#define DIC_TITILESTRING @"title"
#define CELL_HEIGHT 50.0f

@interface MyBillVC ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) BillAcountModel *billAcountModel;//累计投资Model
@property (nonatomic,strong) BillIndexModel *billIndexModel;//本月总览Model
@property (nonatomic,strong) BillDataModel *billDataModel;//起始日期Model
@property (nonatomic,strong) MyBillHeaderCell *myBillHeaderCell;
@property (nonatomic,strong) NSMutableArray *investArr;//投资记录
@property (nonatomic,strong) NSMutableArray *incomeArr;//回款记录
@property (nonatomic, strong) NSMutableArray *componentOneArr;//年份条件
@property (nonatomic, strong) NSMutableArray *componentTwoArr;//月份条件
@property (nonatomic,strong) UIButton *timeBtn;//时间按钮
@property (nonatomic, strong) NSString *result1;//选中的年
@property (nonatomic, strong) NSString *result2;//选中的月
@property (nonatomic,strong) NSString *result;//选择到的年月
@property (nonatomic, strong) UIPickerView *datePicker;//年月选择器
@property (nonatomic, strong) NSArray *pickerData;//年月选择器
@property (nonatomic, copy) NSString *typeStr;//筛选类型
@property (nonatomic, copy) NSString *nowDateStr;//当前时间
@property (nonatomic, copy) NSString *checkDate;//账单时间
@property (nonatomic, strong) UIView *backView;//日期选择蒙板
@property (nonatomic, strong) UILabel *dateLabel;//年份显示lab
@property (nonatomic, assign) BOOL firstTime;//是否是第一次出现

@end

@implementation MyBillVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backGroundColor;
    //标题
    [TitleLabelStyle addtitleViewToMyVC:self withTitle:@"我的账单"];
    //左边返回按钮
    UIButton *leftBtn = [Factory addBlackLeftbottonToVC:self];
    [leftBtn addTarget:self action:@selector(leftBtn:) forControlEvents:UIControlEventTouchUpInside];
    //[self initDataSource];
    [self.view addSubview:self.tableView];
    //时间选择器的创建
    [self CreateDataPickerView];
}
/**
 * 返回
 */
- (void)leftBtn:(UIButton *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
/**
 *请求数据
 */
- (void)getData{
//    __weak typeof(self) weakSelf = self;
//    
//    [DownLoadData postGetAccountLog:^(id obj, NSError *error) {
//        
//    } userId:[HCJFNSUser stringForKey:@"userId"] queryMonth:self.result];
//    //根据月份获取起止日
//    [DownLoadData postGetStartAndEndByMonth:^(id obj, NSError *error) {
//        _billDataModel = [[BillDataModel alloc] initWithDictionary:obj];
//        [self.tableView reloadData];
//    } queryMonth:self.result];
//    //累计投资  累计收益数据请求
//    [DownLoadData postBillCount:^(id obj, NSError *error) {
//        weakSelf.billAcountModel = [[BillAcountModel alloc] initWithDictionary:obj];
//        [self.tableView reloadData];
//    } userId:[HCJFNSUser stringForKey:@"userId"]];
//    //我的账单首页
//    [DownLoadData postBillIndex:^(id obj, NSError *error) {
//        _billIndexModel = [[BillIndexModel alloc] initWithDictionary:obj];
//        [self.tableView reloadData];
//    } userId:[HCJFNSUser stringForKey:@"userId"] queryMonth:self.result];
//    //用户本月部分投资记录
//    [DownLoadData postGetInvestListAllByUserId:^(id obj, NSError *error) {
//        self.investArr = obj[@"SUCCESS"];
//        [self.tableView reloadData];
//    } userId:[HCJFNSUser stringForKey:@"userId"] queryMonth:self.result];
//    //用户本月部分回款记录
//    [DownLoadData postGetCollectListByUserId:^(id obj, NSError *error) {
//        self.incomeArr = obj[@"SUCCESS"];
//        [self.tableView reloadData];
//    } userId:[HCJFNSUser stringForKey:@"userId"] queryMonth:self.result];
}
/**
 *用户本月部分投资记录数组
 */
- (NSMutableArray *)investArr{
    if(!_investArr){
        _investArr = [NSMutableArray array];
    }
    return _investArr;
}
/**
 *用户本月部分回款记录数组
 */
- (NSMutableArray *)incomeArr{
    if(!_incomeArr){
        _incomeArr = [NSMutableArray array];
    }
    return _incomeArr;
}
#pragma mark - 懒加载
- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -1, kScreenWidth, kScreenHeight-NavigationBarHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = SeparatorColor;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
    }
    return _tableView;
}
/**
 *时间按钮
 */
- (UIButton *)timeBtn{
    if(!_timeBtn){
        _timeBtn  = [UIButton buttonWithType:0];
        _timeBtn.frame = CGRectMake(kScreenWidth/2, 60*m6Scale, kScreenWidth/2-170*m6Scale, 30*m6Scale);
        [_timeBtn addTarget:self action:@selector(AlsoJumpToCalendar) forControlEvents:UIControlEventTouchUpInside];
    }
    return _timeBtn;
}
#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 || section == 1) {
        return 1;
    }else if(section == 2){
        //投资记录
        if (self.investArr.count>1) {
            return 2;
        }else{
            return 1;
        }
    }else{
        //回款记录
        if (self.incomeArr.count>1) {
            return 2;
        }else{
            return 1;
        }
    }
}
#pragma mark -cellForRowAtIndexPath
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"cell";
    static NSString *str1 = @"cell1";
    static NSString *str2 = @"cell2";
    static NSString *str3 = @"cell3";
    if (indexPath.section == 0) {
        _myBillHeaderCell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!_myBillHeaderCell) {
            _myBillHeaderCell = [[MyBillHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str
                                 ];
        }
        [self.tableView addSubview:self.timeBtn];
        [_myBillHeaderCell cellForModel:_billAcountModel andDataModel:_billDataModel Year:self.result1 Month:self.result2];
        
        return _myBillHeaderCell;
    }else if (indexPath.section == 1){
        MyBillSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:str1];
        if (!cell) {
            cell = [[MyBillSecondCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str1
                    ];
        }
        [cell cellForModel:_billIndexModel];
        
        return cell;
    }else if(indexPath.section == 2){
        MyBillDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:str2];
        if (!cell) {
            cell = [[MyBillDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str2
                    ];
        }
        if (_investArr.count) {
            [cell cellForModel:_investArr[indexPath.row] withtype:2];
        }else{
            [cell cellForModel:nil withtype:1];
        }
        
        return cell;
    }
    else{
        
        MyBillDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:str3];
        if (!cell) {
            cell = [[MyBillDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str3
                    ];
        }
        if (_incomeArr.count) {
            [cell cellForModel:_incomeArr[indexPath.row] withtype:3];
        }else{
            [cell cellForModel:nil withtype:0];
        }
        
        return cell;
    }
}
#pragma mark -viewForHeaderInSection
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 2 || section == 3){
        UIView *hView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth, CELL_HEIGHT)];
        hView.backgroundColor = [UIColor whiteColor];
        UIButton* eButton = [[UIButton alloc] init];
        UIImageView *imageview = [[UIImageView alloc]init];
        [hView addSubview:imageview];
        [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(hView.mas_left).offset(30*m6Scale);
            make.centerY.equalTo(hView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(36*m6Scale, 36*m6Scale));
        }];//more标签
        UILabel *moreLabel = [Factory CreateLabelWithTextColor:1 andTextFont:28 andText:@"更多>" addSubView:hView];
        moreLabel.textColor = [UIColor lightGrayColor];
        [moreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20*m6Scale);
            make.centerY.mas_equalTo(hView.mas_centerY);
        }];
        //按钮填充整个视图
        eButton.frame = hView.frame;
        [eButton addTarget:self action:@selector(moreButtonAction:)
          forControlEvents:UIControlEventTouchUpInside];
        //把节号保存到按钮tag，以便传递到expandButtonClicked方法
        eButton.tag = section+200;
        
        //设置分组标题
        if (section == 2) {
            [eButton setTitle:@"本月投资记录" forState:UIControlStateNormal];
            imageview.image = [UIImage imageNamed:@"本月投资记录"];
        }else if(section == 3){
            [eButton setTitle:@"本月回款记录" forState:UIControlStateNormal];
            imageview.image = [UIImage imageNamed:@"本月回款记录"];
        }
        [eButton setTitleColor:BlackColor forState:UIControlStateNormal];
        //设置button的图片和标题的相对位置
        //4个参数是到上边界，左边界，下边界，右边界的距离
        eButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [eButton setTitleEdgeInsets:UIEdgeInsetsMake(5*m6Scale,100*m6Scale, 0,0)];//标题
        [eButton setImageEdgeInsets:UIEdgeInsetsMake(35,self.view.bounds.size.width - 25, 0,0)];//图片
        [hView addSubview: eButton];
        
        return hView;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 || section == 1) {
        return 0.01;
    }else{
        return 100*m6Scale;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 || indexPath.section == 1) {
        if (indexPath.section == 1) {
            return 336*m6Scale;
        }else{
            return 336*m6Scale;
        }
    }else if(indexPath.section == 2){
        //投资记录
        if (self.investArr.count) {
            return 100*m6Scale;
        }else{
            return 200*m6Scale;
        }
    }else{
        //回款记录
        if (self.incomeArr.count) {
            return 100*m6Scale;
        }else{
            return 200*m6Scale;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 21*m6Scale;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 2) {
        if (self.investArr.count) {
            //2投资3回款
            PartInvestModel *model = self.investArr[indexPath.row];
            MyBillRecordVC *tempVC = [MyBillRecordVC new];
            tempVC.section = indexPath.section;
            tempVC.investID = [NSString stringWithFormat:@"%@", model.investId];
            [self.navigationController pushViewController:tempVC animated:YES];
        }
    }else if(indexPath.section == 3){
        if (self.incomeArr.count) {
            //2投资3回款
            PartIncomeModel *model = self.incomeArr[indexPath.row];
            MyBillRecordVC *tempVC = [MyBillRecordVC new];
            tempVC.section = indexPath.section;
            tempVC.investID = [NSString stringWithFormat:@"%@", model.collectId];
            [self.navigationController pushViewController:tempVC animated:YES];
        }
    }
}
/**
 *时间选择器的创建
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
        NSString *str = [NSString stringWithFormat:@"%ld年",i];
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
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.backView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.35];
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelChoose)];
    [self.backView addGestureRecognizer:singleTap];
    self.backView.hidden = YES;
    AppDelegate *dategate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [dategate.window addSubview:self.backView];
    
    //选择日期黄底
    UIView *smallView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight * 0.67, kScreenWidth, 75 * m6Scale)];
    smallView.backgroundColor = ButtonColor;
    [self.backView addSubview:smallView];
    
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
    [self.backView addSubview:self.datePicker];
    
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
 *时间标签的点击
 */
- (void)AlsoJumpToCalendar
{
    self.firstTime = NO;
    self.backView.hidden = NO;
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
    if (component == 0) {
        self.result1 = self.componentOneArr[row];
        [self.datePicker reloadComponent:2];
    }
    else if (component == 2) {
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
        
    }else{
        [self.investArr removeAllObjects];
        [self.incomeArr  removeAllObjects];
        self.result = [NSString stringWithFormat:@"%@%@", self.result1, self.result2];
        //请求数据
        [self getData];
    }
    //移除日期选择界面
    self.backView.hidden = YES ;
    //筛选类型置nil
    self.typeStr = nil;
}

//日期选择取消按钮
- (void)cancelChoose{
    self.backView.hidden = YES;;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBarTintColor:navigationColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    UIImage *colorImage = [Factory imageWithColor:[UIColor clearColor] size:CGSizeMake(self.view.frame.size.width, 0.5)];
    [self.navigationController.navigationBar setBackgroundImage:colorImage forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[Factory imageWithColor:[UIColor colorWithWhite:0.5 alpha:1] size:CGSizeMake(self.view.frame.size.width, 0.5)]];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    [self.navigationController.navigationBar setBarTintColor:navigationYellowColor];
    [Factory hidentabar];//隐藏tabar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    
}
/**
 *more按钮点击事件
 */
- (void)moreButtonAction:(UIButton *)sender{
    NSLog(@"moreButtonAction");
    CurrentBillRecordVC *tempVC = [CurrentBillRecordVC new];
    if (sender.tag == 202) {
        //本月投资记录
        tempVC.type = 2;
    }else{
        //本月回款记录
        tempVC.type = 3;
    }
    tempVC.dataString = self.result;
    [self.navigationController pushViewController:tempVC animated:YES];
}
@end
