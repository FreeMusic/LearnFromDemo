//
//  NewAutoVC.m
//  CityJinFu
//
//  Created by hanling on 16/9/27.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "NewAutoVC.h"
#import "NewAutoCell.h"
#import "AutoListModel.h"
#import "AutoBidSettingViewController.h"
#import "AutoBidRecodeViewController.h"
#import "CreatView.h"
#import "ForgetPasswordView.h"

@interface NewAutoVC ()<UITableViewDelegate, UITableViewDataSource, FactoryDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *sectionNumArr;
@property (nonatomic, strong) Reachability *conn;
@property (nonatomic, strong) MJRefreshAutoNormalFooter *footer;//刷新
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableDictionary *dic1;
@property (nonatomic, strong) NSMutableArray *muArray;
@property (nonatomic, strong) AutoListModel *model;//model
@property (nonatomic, strong) CreatView *creatView;//蒙版
@property (nonatomic, copy) NSString *timerRandom;//验证码
@property (nonatomic, copy) NSString *validPhoneExpiredTime;//时间戳
@property (nonatomic, strong) UITextField *textField;//文本框
@property (nonatomic, strong) ForgetPasswordView *passwordView;//验证码输入
@property (nonatomic, strong) NewAutoCell *cell;//cell


@end

@implementation NewAutoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"自动投标"];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = navigationColor;
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];//左边的按钮
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    //自动投标记录
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70*m6Scale, 70*m6Scale)];
    [button setImage:[UIImage imageNamed:@"图层-22-拷贝"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(checkInvestmentRecord) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightBtn;
    //创建蒙版
    _creatView = [[CreatView alloc]initWithFrame:CGRectMake(0,kScreenHeight , kScreenWidth, kScreenHeight)];
    //取到delegate的window，将模版视图添加到window上，达到遮住导航栏的效果
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [delegate.window addSubview:_creatView];
    [delegate.window bringSubviewToFront:_creatView];
    UITapGestureRecognizer * singleRecognizer =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resgister:)];//手势
    singleRecognizer.numberOfTapsRequired = 1;
    [self.creatView addGestureRecognizer:singleRecognizer];
    
    [self.view addSubview:self.textField];

    [self createMyTableView];//tableView
    [self pullDown];//下拉刷新
    //网络请求实时改变
    Factory *factory = [[Factory alloc]init];
    factory.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkStateChanged) name:kReachabilityChangedNotification object:nil];
    self.conn = [Reachability reachabilityForInternetConnection];
    [self.conn startNotifier];
}
/**
 *  验证码输入框
 */
- (UITextField *)textField
{
    if (!_textField) {
        _textField = [UITextField new];
        _textField.delegate = self;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _passwordView = [[ForgetPasswordView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 355 * m6Scale)];
        _textField.inputAccessoryView = _passwordView;
        _passwordView.backgroundColor = [UIColor whiteColor];
        //添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resgister:)];
        tap.numberOfTapsRequired = 1;
        [_passwordView.cancelImageView addGestureRecognizer:tap];
        _textField.hidden = YES;
        [_passwordView.reSendButton addTarget:self action:@selector(sendCodeAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _textField;
}
/**
 重新发送按钮
 */
- (void)sendCodeAction:(UIButton *)button {
    
    [self sendVaildPhoneCode];
    [TimeOut timeOut:button]; //倒计时
}
//点击蒙版退出
- (void)resgister:(UITapGestureRecognizer *)sender{
    if (_textField.text.length == 0) {
        _cell.mySwitch.on = NO;
    }
    [self.textField resignFirstResponder];
    _creatView.frame = CGRectMake(0, -kScreenHeight, kScreenWidth, kScreenHeight);
    //添加动画效果
    CATransition *clip = [[CATransition alloc] init];
    clip.duration = 0.3;
    clip.type = @"fade";
    [_creatView.layer addAnimation:clip forKey:nil];
}
//蒙版的出现
- (void)successViewShowAction {
    
    _creatView.frame = CGRectMake(0, 0,kScreenWidth, kScreenHeight);
    
}
//验证码
- (void)sendVaildPhoneCode
{
    NSUserDefaults *user = HCJFNSUser;
    _timerRandom = [TimerRandom timerRandom];
    NSLog(@"_timerRandom = %@",_timerRandom);
    [DownLoadData postAutoSms:^(id obj, NSError *error) {
        
        NSLog(@"oooo----%@",obj);
        _validPhoneExpiredTime = obj[@"validPhoneExpiredTime"];
        
    } userId:[user objectForKey:@"userId"] andvaildPhoneCode:_timerRandom];
}

/*
*  返回
*/
- (void)onClickLeftItem
{
    if (_nsTag == 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
/**
 *  当有网状态下请求数据
 */
- (void)netWorkStateChanged{
    
    NSInteger state = [Factory checkNetwork];
    if (state == 1 || state == 2) {
        [self serverData];
    }
}
//上拉加载
- (void)example11
{
    _footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(LoadNewData)];
}
//上拉加载
-(void)LoadNewData{
    NSUserDefaults *user = HCJFNSUser;
    //网络监听
    NSInteger state = [Factory checkNetwork];
    if (state == 0) {
        [Factory showFasHud];
    }
    else {
        [DownLoadData postGetAuto:^(id obj, NSError *error) {
            _dic1 = obj[@"SUCCESS1"];
            NSString *total = [NSString stringWithFormat:@"%@",_dic1[@"total"]];
            if (total.intValue <= 10) {
                [_myTableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                _page ++;
                NSString *str = [NSString stringWithFormat:@"%@",_dic1[@"isLastPage"]];
                if ([str isEqualToString:@"0"]) {
                    if (obj[@"SUCCESS"]) {
                        _muArray =[[NSMutableArray alloc]init];
                        _muArray = obj[@"SUCCESS"];
                        [_sectionNumArr addObjectsFromArray:_muArray];
                        [_myTableView reloadData];
                        [_myTableView.mj_footer endRefreshing];
                        _myTableView.tableFooterView = [UIView new];
                    }
                }else  {
                    _muArray =[[NSMutableArray alloc]init];
                    _muArray = obj[@"SUCCESS"];
                    [_sectionNumArr addObjectsFromArray:_muArray];
                    [_myTableView reloadData];
                    [_myTableView.mj_footer endRefreshing];
                    _myTableView.tableFooterView = [UIView new];
                    [_myTableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
            
        } userId:[user objectForKey:@"userId"]];
    }
}
//下拉刷新
- (void)pullDown
{
    _myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(serverData)];
    [_myTableView.mj_header beginRefreshing];
}
/**
 *  服务器数据
 */
- (void)serverData{
    
    NSUserDefaults *user = HCJFNSUser;
    //网络监听
    NSInteger state = [Factory checkNetwork];
    if (state == 0) {
        [Factory showFasHud];
    } else {
        [DownLoadData postGetAuto:^(id obj, NSError *error) {
            
            _sectionNumArr = obj[@"SUCCESS"];
            [_myTableView reloadData];
            _myTableView.backgroundColor = [UIColor whiteColor];
            _myTableView.separatorStyle = YES;
            _dic1 = obj[@"SUCCESS1"];
            NSString *total = [NSString stringWithFormat:@"%@",_dic1[@"total"]];
            if (total.intValue < 10) {
                
            } else {
                [self example11];//上拉加载
                [_myTableView.mj_footer resetNoMoreData];
                _myTableView.mj_footer = _footer;
                _footer.stateLabel.hidden = YES;
                _page = 2;
                _footer.stateLabel.hidden = NO;
            }
            [_myTableView.mj_header endRefreshing];
            _myTableView.tableFooterView = [UIView new];
            
        } userId:[user objectForKey:@"userId"]];
    }
}
/**
 *  自动投标记录
 */
- (void) checkInvestmentRecord {
    
    AutoBidRecodeViewController *autoBid = [[AutoBidRecodeViewController alloc]init];
    [self.navigationController pushViewController:autoBid animated:YES];

}
/**
 createMyTableView
 */
- (void) createMyTableView {
    
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - NavigationBarHeight) style:UITableViewStyleGrouped];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    self.myTableView.separatorColor = SeparatorColor;
    self.myTableView.showsVerticalScrollIndicator = NO;
    self.myTableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.myTableView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionNumArr.count + 1;
//    return self.sectionNumArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 160 * m6Scale;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == self.sectionNumArr.count) {
        NSString *str = @"添加按钮";
        UITableViewCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *remindLab = [[UILabel alloc] init];
            remindLab.text = @"添加自动投标计划\n+";
            remindLab.numberOfLines = 0;
            remindLab.textAlignment = NSTextAlignmentCenter;
            remindLab.font = [UIFont systemFontOfSize:30 * m6Scale];
            [cell addSubview:remindLab];
            [remindLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(cell.mas_centerX);
                make.centerY.equalTo(cell.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(kScreenWidth * 0.8, 120 * m6Scale));
            }];
        }
        return cell;
    }
    else {
        NSString *str = @"自动投标";
        _cell = [self.myTableView dequeueReusableCellWithIdentifier:str];
        if (!_cell) {
            _cell = [[NewAutoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
            _cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        //开关的点击事件
        [_cell.mySwitch addTarget:self action:@selector(mySwitch:) forControlEvents:UIControlEventValueChanged];
        
        _model = _sectionNumArr[indexPath.section];
        [_cell newAutoListModel:_model andIndexPath:indexPath];
        return _cell;
    }
}
/**
 开关的点击事件
 */
- (void)mySwitch:(UISwitch *)sender{
    
    NSLog(@"%@-----%@",_model.ID,_textField.text);
    NSUserDefaults *user = HCJFNSUser;
    if (sender.on) {
        NSLog(@"111");
        
        [self successViewShowAction];//蒙版显示
        [self.textField becomeFirstResponder];
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self sendVaildPhoneCode];//验证码
            [TimeOut timeOut:self.passwordView.reSendButton]; //倒计时
        });
    }else{
         NSLog(@"8888++++%@",[user objectForKey:@"zyyLockId"]);
        
        //修改自动投标
        [DownLoadData postModifyAuto:^(id obj, NSError *error) {
            
            NSLog(@"%@",obj);

            
        } andUserId:[user objectForKey:@"userId"] andId:[user objectForKey:@"zyyLockId"] andvalidPhoneExpiredTime:@"" andjsCode:@"" andinputCode:@"" anditemStatus:@"0"];
        
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 18 * m6Scale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
#pragma mark -didSelectRowAtIndexPath
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == self.sectionNumArr.count) {
        //跳转到自动投资页面
        AutoBidSettingViewController *autoBid = [AutoBidSettingViewController new];
        //是否锁定
        autoBid.isOpen = @"2";
        autoBid.itemStatus = @"1";
        NSUserDefaults *user = HCJFNSUser;//控制开关的不锁定
        [user setValue:@"0" forKey:@"autoZyy"];
        [user synchronize];
        [self.navigationController pushViewController:autoBid animated:YES];
    }else{
        AutoListModel *model = self.sectionNumArr[indexPath.section];
        //跳转到自动投资页面
        AutoBidSettingViewController *autoBid = [AutoBidSettingViewController new];
        if (model.itemAmount.integerValue == 99999999) {
            autoBid.investmoney = @"默认金额不限";//标的金额
        }else{
//             autoBid.investmoney = model.itemAmount.stringValue;//标的金额
            autoBid.investmoney = [NSString stringWithFormat:@"%@元",model.itemAmount.stringValue];//标的金额
        }
        //期限
        if (model.itemDayMin.integerValue == 0 && model.itemDayMax.integerValue == 999) {
            autoBid.dataStr = @"自动 ~ 自动";
        }else if (model.itemDayMin.integerValue == 0 || model.itemDayMax.integerValue == 999){
            if (model.itemDayMin.integerValue == 0) {
                autoBid.dataStr = [NSString stringWithFormat:@"自动 ~ %@天",model.itemDayMax.stringValue];
            }else if(model.itemDayMax.integerValue == 999){
                autoBid.dataStr = [NSString stringWithFormat:@"%@天 ~ 自动",model.itemDayMin.stringValue];
            }
        }else{
            if (model.itemLockStatus.intValue == 1) {
                autoBid.dataStr = @"自动 ~ 自动";
            }else{
                //投标期限最大和最小的判断
                if (model.itemDayMin.integerValue == model.itemDayMax.integerValue) {
                    autoBid.dataStr = [NSString stringWithFormat:@"%@天",model.itemDayMin.stringValue];
                }else{
                    autoBid.dataStr = [NSString stringWithFormat:@"%@天 ~ %@天",model.itemDayMin.stringValue,model.itemDayMax.stringValue];
                }
            }
        }
        //利率
        if (model.itemRateMin.integerValue == 0 && model.itemRateMax.integerValue == 99) {
            
            autoBid.incomeStr = @"自动 ~ 自动";
        }else if (model.itemRateMin.integerValue == 0 || model.itemRateMax.integerValue == 99){
            if (model.itemRateMin.integerValue == 0) {
                autoBid.incomeStr = [NSString stringWithFormat:@"自动 ~ %@%%",model.itemRateMax.stringValue];
            }else if(model.itemRateMax.integerValue == 99){
                autoBid.incomeStr = [NSString stringWithFormat:@"%@%% ~ 自动",model.itemRateMin.stringValue];
            }
        }else{
            if (model.itemLockStatus.intValue == 1) {
                autoBid.incomeStr = @"自动 ~ 自动";
            }else{
                //利率的最大和最小判断
                if (model.itemRateMin.stringValue == model.itemRateMax.stringValue) {
                      autoBid.incomeStr = [NSString stringWithFormat:@"%@%%",model.itemRateMin.stringValue];
                }else{
                      autoBid.incomeStr = [NSString stringWithFormat:@"%@%% ~ %@%%",model.itemRateMin.stringValue,model.itemRateMax.stringValue];
                }
            }
        }
        //标的ID
        autoBid.autoId = model.ID.stringValue;
        //是否锁定
        autoBid.isOpen = model.itemLockStatus.stringValue;
        //开关的状态
        autoBid.itemStatus = model.itemStatus.stringValue;
        //锁定期限
        autoBid.lockDateStr = [NSString stringWithFormat:@"%d",model.itemLockCycle.intValue / 30];
        //加息利率
        autoBid.interestStr = [NSString stringWithFormat:@"%.1f",model.itemAddRate.doubleValue];
        //投资金额类型
        autoBid.investType = model.itemAmountType.stringValue;
        [self.navigationController pushViewController:autoBid animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AutoListModel *model = self.sectionNumArr[indexPath.section];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //弹出框
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:TitleMes message:@"您是否要删除自动投标!" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //删除自动投标
            [DownLoadData postDeleteAuto:^(id obj, NSError *error) {
                if ([obj[@"result"] isEqualToString:@"success"]) {
                    [self.sectionNumArr removeObjectAtIndex:indexPath.section];
                    [self.myTableView reloadData];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }else{
                    
                }
                NSLog(@"99999+++++%@",obj);
            } autoId:model.ID.stringValue];
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }
}
#pragma mark - textfield Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUserDefaults *user = HCJFNSUser;
    NSString *text;
    if ([string isEqualToString:@""] || [string integerValue] || [string isEqualToString:@"."] || [string isEqualToString:@"0"]) {
        
        if ([string isEqualToString:@""]) {
            //获取到上一次操作的字符串长度
            NSInteger clip = textField.text.length;
            //截取字符串 将最后一个字符删除
            text = [textField.text substringToIndex:clip - 1];
            
        }else {
            
            text = [textField.text stringByAppendingString:string];
        }
    }
    
    if (text.length == 6) {
        
        self.passwordView.passwordText = text;
        [DownLoadData postCheckOutGesture:^(id obj, NSError *error) {
            
            NSLog(@"%@",obj);
            
            if ([obj[@"result"] isEqualToString:@"success"]) {
                
                [self.textField resignFirstResponder];
                _creatView.frame = CGRectMake(0, -kScreenHeight, kScreenWidth, kScreenHeight);
                //添加动画效果
                CATransition *clip = [[CATransition alloc] init];
                clip.duration = 0.3;
                clip.type = @"fade";
                [_creatView.layer addAnimation:clip forKey:nil];
                //修改自动投标
                [DownLoadData postModifyAuto:^(id obj, NSError *error) {
                    
                    NSLog(@"%@",obj);
                   
                    
                } andUserId:[user objectForKey:@"userId"] andId:_model.ID.stringValue andvalidPhoneExpiredTime:_validPhoneExpiredTime andjsCode:_timerRandom andinputCode:text anditemStatus:@"1"];
                
            }else {
                
                
                self.textField.text = nil;
                self.passwordView.passwordText = nil;
                if (obj[@"messageText"]) {
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:obj[@"messageText"] preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }]];
                    
                    [self presentViewController:alert animated:YES completion:nil];
                }
            }
        } mobile:self.passwordView.phoneNum inputCode:text validTime:self.validPhoneExpiredTime jsCode:self.timerRandom];
        return YES;
        
    }else if (text.length >= 7) {
        
        return NO;
        
    }else {
        
        self.passwordView.passwordText = text;
        
        return YES;
    }
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [Factory hidentabar];//隐藏
    [Factory navgation:self];//导航
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
