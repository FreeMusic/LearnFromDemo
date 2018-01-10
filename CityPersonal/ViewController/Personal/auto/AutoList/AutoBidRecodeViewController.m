//
//  VIPViewController.m
//  CityJinFu
//
//  Created by mic on 16/9/27.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "AutoBidRecodeViewController.h"
#import "AutoBidRecodeTableViewCell.h"
#import "AutoBidRecodeModel.h"

@interface AutoBidRecodeViewController ()<UITableViewDelegate, UITableViewDataSource,FactoryDelegate, UIPickerViewDataSource,UIPickerViewDelegate>{
    NSMutableDictionary *_dic1;
    NSMutableArray *_muArray;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *array;//投资信息个数
@property (nonatomic, strong) NSMutableDictionary *dataDic;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *footer;//刷新
@property (nonatomic, strong) UIView *backgroundImage;
@property (nonatomic, strong) Reachability *conn;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UIButton *dateBtn;//日期按钮
@property (nonatomic, strong) UIImageView *dateImg;//日期选择下标按钮
@property (nonatomic, strong) NSString *result1;//选中的年
@property (nonatomic, strong) NSString *result2;//选中的月
@property (nonatomic,strong) NSString *result;//选择到的年月
@property (nonatomic, strong) UIPickerView *datePicker;//年月选择器
@property (nonatomic, strong) NSArray *pickerData;//年月选择器
@property (nonatomic, copy) NSString *typeStr;//筛选类型
@property (nonatomic, copy) NSString *nowDateStr;//当前时间
@property (nonatomic, copy) NSString *checkDate;//账单时间
@property (nonatomic, strong) UIView *backView;//日期选择蒙板
@property (nonatomic, strong) NSMutableArray *componentOneArr;//年份条件
@property (nonatomic, strong) NSMutableArray *componentTwoArr;//月份条件
@property (nonatomic, strong) UILabel *dateLabel;//年份显示lab
@property (nonatomic, assign) BOOL firstTime;//是否是第一次出现
@property (nonatomic, assign) NSInteger monthComponent;

@end

@implementation AutoBidRecodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = backGroundColor;
    [self.view addSubview:self.tableView];
    //标题
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"自动投标记录"];
    //(121,196)
    _backgroundImage = [[UIView alloc]initWithFrame:CGRectMake((_tableView.frame.size.width -130)/2, (_tableView.frame.size.height -130)/2-50, 130, 130)];
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];//左边的按钮
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    //日期选择图标
    _dateImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"item_zd_2"]];
    [self.navigationController.view addSubview:_dateImg];
    [_dateImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(18*m6Scale, 9*m6Scale));
        make.right.mas_equalTo(-30*m6Scale);
        if (kStatusBarHeight > 20) {
            make.top.mas_equalTo(130*m6Scale);
        }else{
            make.top.mas_equalTo(75*m6Scale);
        }
    }];
    //日期按钮
    _dateBtn = [UIButton buttonWithType:0];
    [_dateBtn setTitleColor:[UIColor blackColor] forState:0];
    [_dateBtn setTitle:@"2017年6月" forState:0];
    [_dateBtn addTarget:self action:@selector(AlsoJumpToCalendar) forControlEvents:UIControlEventTouchUpInside];
    _dateBtn.titleLabel.font = [UIFont systemFontOfSize:26*m6Scale];
    [self.navigationController.view addSubview:_dateBtn];
    [_dateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_dateImg.mas_left);
        make.width.mas_equalTo(180*m6Scale);
        make.height.mas_equalTo(30*m6Scale);
        if (kStatusBarHeight > 20) {
            make.top.mas_equalTo(120*m6Scale);
        }else{
            make.top.mas_equalTo(65*m6Scale);
        }
    }];
    
    //网络请求实时改变
    Factory *factory = [[Factory alloc]init];
    factory.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkStateChanged) name:kReachabilityChangedNotification object:nil];
    self.conn = [Reachability reachabilityForInternetConnection];
    [self.conn startNotifier];
    
    [self.view addSubview:self.tableView];
    
    //时间选择器的创建
    [self CreateDataPickerView];
}
/**
 *  返回
 */
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITableView Lazyloading
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth, kScreenHeight-100*m6Scale) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = SeparatorColor;
//        _tableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    }
    return _tableView;
}
- (void)netWorkStateChanged{
    NSInteger state = [Factory checkNetwork];
    //当有网状态下请求数据
    if (state == 1 || state == 2) {
        [self serverData];
    }
}
//上拉加载
- (void)example11
{
    _footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(LoadNewData)];
}
/**
 *数据数组
 */
- (NSMutableArray *)array{
    if(!_array){
        _array = [NSMutableArray array];
    }
    return _array;
}
/**
 *数据字典
 */
- (NSMutableDictionary *)dataDic{
    if(!_dataDic){
        _dataDic = [NSMutableDictionary dictionary];
    }
    return _dataDic;
}
//上拉加载
-(void)LoadNewData{
    //网络监听
    NSInteger state = [Factory checkNetwork];
    if (state == 0) {
        [Factory showFasHud];
    }
    else {
        [DownLoadData postGetLists:^(id obj, NSError *error) {
            self.dataDic = obj[@"SUCCESS1"];
            NSString *total = [NSString stringWithFormat:@"%@",_dic1[@"total"]];
            if (total.intValue <= 10) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                _page ++;
                NSString *str = [NSString stringWithFormat:@"%@",_dic1[@"isLastPage"]];
                if ([str isEqualToString:@"0"]) {
                    if (obj[@"SUCCESS"]) {
                        _muArray =[[NSMutableArray alloc]init];
                        _muArray = obj[@"SUCCESS"];
                        [_array addObjectsFromArray:_muArray];
                        [_tableView reloadData];
                        [_tableView.mj_footer endRefreshing];
                        _tableView.tableFooterView = [UIView new];
                    }
                }else  {
                    _muArray =[[NSMutableArray alloc]init];
                    _muArray = obj[@"SUCCESS"];
                    [_array addObjectsFromArray:_muArray];
                    [_tableView reloadData];
                    [_tableView.mj_footer endRefreshing];
                    _tableView.tableFooterView = [UIView new];
                    [_tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }

        } pageNum:[NSString stringWithFormat:@"%ld", _page] pageSize:@"10" userId:[HCJFNSUser stringForKey:@"userId"] investType:@"10" queryMonth:self.result];
    }
}
//下拉刷新
- (void)pullDown
{
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(serverData)];
    [_tableView.mj_header beginRefreshing];
}
/**
 *  服务器数据
 */
- (void)serverData{
    //网络监听
    NSInteger state = [Factory checkNetwork];
    if (state == 0) {
        [Factory showFasHud];
    } else {
        [DownLoadData postGetLists:^(id obj, NSError *error) {
            [self.array removeAllObjects];
            self.array = obj[@"SUCCESS"];
            if (_array.count == 0) {
                
                _backgroundImage.backgroundColor = [[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"无数据"]];
                [_tableView addSubview:_backgroundImage];
                self.tableView.separatorStyle = NO;
                [_tableView.mj_header endRefreshing];
            }
            else {
                [_backgroundImage removeFromSuperview];
                [self.tableView reloadData];
                self.tableView.backgroundColor = [UIColor whiteColor];
                self.tableView.separatorStyle = YES;
                self.dataDic = obj[@"SUCCESS1"];
                NSString *total = [NSString stringWithFormat:@"%@",_dic1[@"total"]];
                if (total.intValue < 10) {
                    
                } else {
                    [self example11];//上拉加载
                    [_tableView.mj_footer resetNoMoreData];
                    _tableView.mj_footer = _footer;
                    _footer.stateLabel.hidden = YES;
                    _page = 2;
                    _footer.stateLabel.hidden = NO;
                }

                [_tableView.mj_header endRefreshing];
                _tableView.tableFooterView = [UIView new];
            }
            
            [_tableView reloadData];

        } pageNum:@"1" pageSize:@"10" userId:[HCJFNSUser stringForKey:@"userId"] investType:@"10" queryMonth:self.result];
    }
}
#pragma mark -numberOfRows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return _array.count;
    return self.array.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
#pragma mark -cellForRow
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = HCJF;
    AutoBidRecodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[AutoBidRecodeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    //model层数据
    AutoBidRecodeModel *model = self.array[indexPath.row];
    [cell updateCellWithRecordModel:model andIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 21*m6Scale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180*m6Scale;
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
    [_dateBtn setTitle:self.result forState:0];
    //请求数据
    [self pullDown];
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
        _monthComponent = row;
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
        
        self.result = [NSString stringWithFormat:@"%@%@", self.result1, self.result2];
        [_dateBtn setTitle:self.result forState:0];
        //请求数据
        [self serverData];
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _dateBtn.hidden = NO;
    _dateImg.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    _dateBtn.hidden = YES;
    _dateImg.hidden = YES;
}

@end
