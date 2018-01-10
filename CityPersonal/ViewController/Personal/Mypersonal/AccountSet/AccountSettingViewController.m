//
//  AccountSettingViewController.m
//  CityJinFu
//
//  Created by 姜姜敏 on 16/8/18.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "AccountSettingViewController.h"
#import "ProtectSafeViewController.h"
#import "PhoneVC.h"
#import "NoticeVC.h"
#import "NewSignVC.h"
#import "GetBackVC.h"
#import "ActivityVC.h"
#import "MyBankCardVC.h"
#import "AccountCheckVC.h"
#import "DealPswVC.h"
#import "ScanIdentityVC.h"
#import "SetDealPswVC.h"
#import "OpenAlertView.h"
#import "AuthenticationVC.h"
#import "FinalDecisionVC.h"
#import "BidCardFirstVC.h"
#import "MywelfareVC.h"

@interface AccountSettingViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSString *userPhoneNum; //用户手机号码
@property (nonatomic, copy) NSString *cachesStr; //缓存
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) NSString *status;//用户实名的状态
@property (nonatomic, strong) OpenAlertView * openAlert;

@end

@implementation AccountSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backGroundColor;
    //标题
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"账户设置"];
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];//左边的按钮
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.tableView];
    [self serverData];//服务器数据
    [self version];//版本字体
    
}
/**
 版本字体
 */
- (void)version{
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    UILabel *versionLab = [Factory version:appCurVersion];
    [self.view addSubview:versionLab];
    [versionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-80 * m6Scale-KSafeBarHeight);
    }];
}
/**
 *  返回
 */
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  后台数据
 */
- (void)serverData{
    self.userPhoneNum = _phoneNum;
    [self.tableView reloadData];
}
#pragma mark - 懒加载
- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.separatorColor = SeparatorColor;
    }
    return _tableView;
}
#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 2;
    }else if(section == 1){
        return 4;
    }else{
        return 2;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"accountSet"];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:24*m6Scale];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"accountSet"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    //组一,二名称
    NSArray *nameArrOne = @[@"手机号码",@"登录密码",@"账户安全", @"身份认证"];
    NSArray *nameArrTwo = @[@"通知设置",@"清理缓存"];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"我的银行卡";
            cell.detailTextLabel.text = @"查看绑定的银行卡";
            cell.imageView.image = [UIImage imageNamed:@"存管账户"];
        }else{
            cell.textLabel.text = @"交易密码";
            cell.imageView.image = [UIImage imageNamed:@"jiaoyimima"];
        }
    }
    if (indexPath.section == 1) {
        
        cell.textLabel.text = nameArrOne[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:nameArrOne[indexPath.row]];
        if (indexPath.row == 0) {
            NSString *mobile = [HCJFNSUser stringForKey:@"userMobile"];
            NSString *numberString = [mobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            
            cell.detailTextLabel.text = numberString;
            cell.accessoryType = UITableViewCellAccessoryNone;
            
        }else if (indexPath.row == 2){
            cell.detailTextLabel.text = @"开启手势或指纹密码";
        }else if (indexPath.row == 3){
            cell.detailTextLabel.text = @"保护您的资金安全";
        }
    }else if(indexPath.section == 2){
        cell.imageView.image = [UIImage imageNamed:nameArrTwo[indexPath.row]];
        cell.textLabel.text = nameArrTwo[indexPath.row];
        if (indexPath.row == 1) {
            cell.detailTextLabel.text = self.cachesStr;//缓存
        }
    }
    cell.detailTextLabel.font = [UIFont systemFontOfSize:26*m6Scale];
    
    return cell;
}


#pragma mark -didSelectRowAtIndexPath
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row) {
            //查询交易密码是否设置接口
            [DownLoadData postCheckTradingPs:^(id obj, NSError *error) {
                self.status = [NSString stringWithFormat:@"%@", obj[@"realnameStatus"]];
                if ([obj[@"result"] isEqualToString:@"success"]) {
                    NSString *password = [NSString stringWithFormat:@"%@", obj[@"password"]];
                    if ([password isEqualToString:@"0"]) {
                        //实名前查询老用户实名信息
                        [DownLoadData postRealNameInformation:^(id obj, NSError *error) {
                            //首先根据realnameStatus该字段判断用户是否实名过
                            self.status = [NSString stringWithFormat:@"%@", obj[@"realnameStatus"]];
                            //用户的姓名
                            NSString *realName = [NSString stringWithFormat:@"%@", obj[@"realname"]];
                            //当用户想要去实名认证的时候.需要获得用户的名字和身份证号
                            NSString *identifyCard = [NSString stringWithFormat:@"%@", obj[@"identifyCard"]];
                            NSString *realnameStatus = [NSString stringWithFormat:@"%@", obj[@"realnameStatus"]];
                            //提示用户实名
                            [self alertActionWithUserName:realName identifyCard:identifyCard status:realnameStatus];
                        } userId:[HCJFNSUser stringForKey:@"userId"]];
                    }else{
                        //                        //老用户直接跳转至设置交易密码界面
                        //                        SetDealPswVC *tempVC = [SetDealPswVC new];
                        //                        [self.navigationController pushViewController:tempVC animated:YES];
                        
                        //交易密码
                        DealPswVC *tempVC = [DealPswVC new];
                        //tempVC.setPsw = 1;
                        [self.navigationController pushViewController:tempVC animated:YES];
                    }
                }else{
                    [Factory alertMes:obj[@"messageText"]];
                }
                //                if (self.status.integerValue) {
                //                }else{
                //                    //当用户想要去实名认证的时候.需要获得用户的名字和身份证号
                //                    NSString *realName = [NSString stringWithFormat:@"%@", obj[@"realname"]];
                //                    NSString *identifyCard = [NSString stringWithFormat:@"%@", obj[@"identifyCard"]];
                //                    NSString *realnameStatus = [NSString stringWithFormat:@"%@", obj[@"realnameStatus"]];
                //                    //提示用户实名
                //                    [self alterUserRealNameByUserName:realName identifyCard:identifyCard realnameStatus:realnameStatus];
                //                }
            } userId:[HCJFNSUser stringForKey:@"userId"]];
        }else{
            //实名前查询老用户实名信息
            [DownLoadData postRealNameInformation:^(id obj, NSError *error) {
                //首先根据realnameStatus该字段判断用户是否实名过
                self.status = [NSString stringWithFormat:@"%@", obj[@"realnameStatus"]];
                //用户的姓名
                NSString *realName = [NSString stringWithFormat:@"%@", obj[@"realname"]];
                if (self.status.integerValue) {
                    //查看我的银行卡
                    MyBankCardVC *tempVC = [MyBankCardVC new];
                    tempVC.userName = realName;
                    [self.navigationController pushViewController:tempVC animated:YES];
                }else{
                    //当用户想要去实名认证的时候.需要获得用户的名字和身份证号
                    NSString *identifyCard = [NSString stringWithFormat:@"%@", obj[@"identifyCard"]];
                    NSString *realnameStatus = [NSString stringWithFormat:@"%@", obj[@"realnameStatus"]];
                    //提示用户实名
                    [self alertActionWithUserName:realName identifyCard:identifyCard status:realnameStatus];
                }
            } userId:[HCJFNSUser stringForKey:@"userId"]];
        }
    }else if (indexPath.section == 1) {
        //手机号码
        if (indexPath.row == 0) {
            PhoneVC *phone = [PhoneVC new];
            phone.phoneNum = self.userPhoneNum;
            
            //[self.navigationController pushViewController:phone animated:YES];
        }
        //登录密码
        else if (indexPath.row == 1) {
            
            GetBackVC *getBackVC = [[GetBackVC alloc] init];
            [self.navigationController pushViewController:getBackVC animated:YES];
        }
        //账户安全
        else if(indexPath.row == 2){
            ProtectSafeViewController *safeVC = [[ProtectSafeViewController alloc] init];
            [self.navigationController pushViewController:safeVC animated:YES];
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            //实名前查询老用户实名信息
            [DownLoadData postRealNameInformation:^(id obj, NSError *error) {
                NSString *realName = [NSString stringWithFormat:@"%@", obj[@"realname"]];
                //首先根据realnameStatus该字段判断用户是否实名过
                NSString *status = [NSString stringWithFormat:@"%@", obj[@"realnameStatus"]];
                if (status.integerValue) {
                    //用户实名过  判断他是否绑过卡
                    [DownLoadData postGetBankByUserId:^(id obj, NSError *error) {
                        [hud hideAnimated:YES];
                        NSString *result = obj[@"result"];
                        if ([result isEqualToString:@"success"]) {
                            //验证通过
                            [self doFaceCheck];
                        }else {
                            //跳转至绑定银行卡页面
                            BidCardFirstVC *tempVC = [BidCardFirstVC new];
                            tempVC.userName = realName;//用户真实姓名
                            [self.navigationController pushViewController:tempVC animated:YES];
                        }
                    } userId:[HCJFNSUser objectForKey:@"userId"]];
                }else{
                    [hud hideAnimated:YES];
                    NSString *identifyCard = [NSString stringWithFormat:@"%@", obj[@"identifyCard"]];
                    NSString *realnameStatus = [NSString stringWithFormat:@"%@", obj[@"realnameStatus"]];
                    //提示实名
                    [self alertActionWithUserName:realName identifyCard:identifyCard status:realnameStatus];
                }
            } userId:[HCJFNSUser stringForKey:@"userId"]];
        }
    }else {
        //通知设置
        if (indexPath.row == 0) {
            NoticeVC *notice = [NoticeVC new];
            [self.navigationController pushViewController:notice animated:YES];
        }
        //清理缓存
        else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"清除缓存" message:[NSString stringWithFormat:@"现有缓存:%@",self.cachesStr] preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self clearCatch];//清理缓存
                NSInteger fileSize = [self getCatchSize];
                self.cachesStr = [NSString stringWithFormat:@"%.2fMB",fileSize / 1024.0 / 1024.0];
                [_tableView reloadData];
                
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}
/**
 *   人脸识别校验
 */
- (void)doFaceCheck{
    //人脸识别
    [DownLoadData postFaceAuthent:^(id obj, NSError *error) {
        //success
        if ([obj[@"result"] isEqualToString:@"success"]) {
            NSString *bizNo = [NSString stringWithFormat:@"%@", obj[@"bizNo"]];
            //假如bizNo是空的话 说明他是老用户  直接跳转提现页面
            if ([Factory theidTypeIsNull:bizNo]) {
                //老用户
                [Factory addAlertToVC:self withMessage:obj[@"messageText"]];
            }else{
                if (![obj[@"face"] isKindOfClass:[NSDictionary class]]) {
                    // 用户需要进行人脸识别校验
                    AuthenticationVC *tempVC= [[AuthenticationVC alloc] init];
                    tempVC.bizNo = bizNo;//人脸识别因子
                    tempVC.reviewType = NeedReview_NO;
                    [self.navigationController pushViewController:tempVC animated:YES];
                }else{
                    NSString *count = obj[@"face"][@"tryTimes"];
                    NSString *auditStatus = [NSString stringWithFormat:@"%@", obj[@"face"][@"auditStatus"]];
                    //人脸识别跳转页面判断
                    [self judgeSkipViewControllerWithTryTimes:count auditStatus:auditStatus isFaceSuccess:[NSString stringWithFormat:@"%@", obj[@"face"][@"isFaceSuccess"]] bizNo:bizNo];
                }
            }
        }else{
            //else 未知错误 提示用户
            [Factory alertMes:obj[@"messageText"]];
        }
        
    } userId:[HCJFNSUser stringForKey:@"userId"]];
}
/**
 *  提示用户去开户
 */
- (void)alertActionWithUserName:(NSString *)userName identifyCard:(NSString *)identifyCard status:(NSString *)status{
    self.openAlert = [[OpenAlertView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:self.openAlert];
    __weak typeof(self.openAlert) openSelf = self.openAlert;
    __weak typeof(self) weakSelf = self;
    [self.openAlert setButtonAction:^(NSInteger tag) {
        [openSelf removeFromSuperview];
        if (tag == 0) {
            ScanIdentityVC *tempVC = [ScanIdentityVC new];
            tempVC.userName = userName;
            tempVC.identifyCard = identifyCard;
            tempVC.realnameStatus = status;
            tempVC.type = 20;//一个特殊的标志 确保用户在绑卡完成之后 能够返回到账户设置
            [weakSelf.navigationController pushViewController:tempVC animated:YES];
        }else{
            MywelfareVC *tempVC = [MywelfareVC new];
            
            [weakSelf.navigationController pushViewController:tempVC animated:YES];
        }
    }];
}
/**
 *   人脸识别跳转页面判断
 */
- (void)judgeSkipViewControllerWithTryTimes:(NSString *)count auditStatus:(NSString *)auditStatus isFaceSuccess:(NSString *)isFaceSuccess bizNo:(NSString *)bizNo{
    //成功
    if ([isFaceSuccess isEqualToString:@"1"]) {
        FinalDecisionVC *tempVC = [[FinalDecisionVC alloc] init];
        tempVC.decision = FinalDecision_Success;
        [self.navigationController pushViewController:tempVC animated:YES];
    }else{
        if (auditStatus.intValue == 0 && count.intValue) {
            //人脸识别 加 人工审核 页面
            AuthenticationVC *tempVC= [[AuthenticationVC alloc] init];
            tempVC.bizNo = bizNo;//人脸识别因子
            tempVC.reviewType = NeedReview_YES;//需要人工审核
            [self.navigationController pushViewController:tempVC animated:YES];
        }else if(auditStatus.intValue == 2){
            //审核中
            FinalDecisionVC *tempVC = [[FinalDecisionVC alloc] init];
            tempVC.decision = FinalDecision_Wait;
            [self.navigationController pushViewController:tempVC animated:YES];
        }else if(auditStatus.intValue == 1){
            //审核成功
            FinalDecisionVC *tempVC = [[FinalDecisionVC alloc] init];
            tempVC.decision = FinalDecision_Success;
            [self.navigationController pushViewController:tempVC animated:YES];
        }else if (auditStatus.intValue == -1){
            //人工审核失败(跳转人工审核失败页面)
            FinalDecisionVC *tempVC = [[FinalDecisionVC alloc] init];
            tempVC.decision = FinalDecision_Failure;
            tempVC.bizNo = bizNo;//人脸识别因子
            [self.navigationController pushViewController:tempVC animated:YES];
        }else if (auditStatus.intValue == 0 && count.intValue == 0){
            // 用户需要进行人脸识别校验
            AuthenticationVC *tempVC= [[AuthenticationVC alloc] init];
            tempVC.bizNo = bizNo;//人脸识别因子
            tempVC.reviewType = NeedReview_NO;
            [self.navigationController pushViewController:tempVC animated:YES];
        }
    }
}
#pragma mark -viewForFooterInSection
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 2) {
        UIView *footView = [[UIView alloc]init];
        //退出登录按钮
        UIButton *logoutButton = [Factory ButtonWithTitle:@"安全退出" andTitleColor:[UIColor whiteColor] andButtonbackGroundColor:ButtonColor andCornerRadius:10 addTarget:self action:@"logoutButton:" addSubView:footView];
        [logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(footView.mas_centerX);
            make.centerY.equalTo(footView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(666 * m6Scale, 90 * m6Scale));
        }];
        return footView;
    }else{
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90 * m6Scale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 300*m6Scale;
    }else{
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 18 * m6Scale;
}

/**
 *  退出登录
 */
- (void)logoutButton:(UIButton *)sender{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确定退出登录" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSUserDefaults *user = HCJFNSUser;
        //存储到本地的数据在退出登录的时候删除掉
        NSArray *array = @[@"result",@"userId",@"switchGesture",@"userIcon",@"gesturePassword",@"fingerSwitch",@"gestureLock",@"userToken", @"bidBankCard"];
        UserDefaults(@"fail", @"sxyRealName")
        for (int i = 0; i < array.count; i++) {
            [user removeObjectForKey:array[i]];
            [user synchronize];
        }
        //退出登录，需要注销网易七鱼
        [[QYSDK sharedSDK] logout:^{
            NewSignVC *signVC = [[NewSignVC alloc] init];
            signVC.presentTag = @"1";
            [self presentViewController:signVC animated:YES completion:^{
                [self.navigationController popToRootViewControllerAnimated:NO];
            }];
        }];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}
/**
 拿到缓存文件夹
 */
- (NSInteger)getCatchSize
{
    NSInteger fileSize = 0;
    
    //拿到缓存文件夹
    NSString *catchPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //拿到缓存文件夹下的所有文件的属性
    NSArray *fileEnumerator = [[NSFileManager defaultManager] subpathsAtPath:catchPath];
    //所有的文件的名称
    for (NSString *fileName in fileEnumerator) {
        //所有文件的路径
        NSString *filePath = [catchPath stringByAppendingPathComponent:fileName];
        //所有文件的大小
        NSDictionary *attDic = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        //   计算大小
        fileSize += [attDic fileSize];
    }
    
    return fileSize;
}
/**
 清除
 */
- (void)clearCatch
{
    //拿到缓存文件夹
    NSString *catchPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //清除
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:catchPath];
    
    for ( NSString *p  in files) {
        
        NSError *error;
        
        NSString *path = [catchPath stringByAppendingPathComponent:p];
        
        if ([[ NSFileManager defaultManager ]  fileExistsAtPath :path]) {
            
            [[ NSFileManager defaultManager ]  removeItemAtPath :path  error :&error];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [Factory hidentabar];
    NSInteger fileSize = [self getCatchSize];
    self.cachesStr = [NSString stringWithFormat:@"%.2fMB",fileSize / 1024.0 / 1024.0];
    //导航设置
    //设置透明度
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = navigationColor;
    self.navigationController.navigationBar.hidden = NO;
}

@end
