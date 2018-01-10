//
//  ProtectSafeViewController.m
//  CityJinFu
//
//  Created by 姜姜敏 on 16/8/17.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "ProtectSafeViewController.h"
#import "GestureViewController.h"
#import "FingermarkViewController.h"
#import "AppDelegate.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "SignViewController.h"
#import "LockTestViewController.h"
#import "NewSignVC.h"

@interface ProtectSafeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *protectTableView; //个人保护tableview
@property (nonatomic, strong) UISwitch *fingerSwitch; //TouchID开关
@property (nonatomic, strong) UISwitch *protectSwitch; //密码保护开关
@property (nonatomic, strong) UISwitch *gestureSwitch; //手势密码开关
@property (nonatomic, strong) UIView *headerView;//tableView自定义的头部视图
@property (nonatomic, strong) UIImageView *fingerView;//指纹密码图标
@property (nonatomic, strong) UIImageView *gestureView;//手势密码图标
@property (nonatomic, assign) NSInteger changeTag;//状态改变
@property (nonatomic, strong) UILabel *closeLabel;//关闭标签

@end

@implementation ProtectSafeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏设置
    self.navigationController.navigationBar.translucent = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.navigationController.navigationBar.barTintColor = navigationColor;
    //标题
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"账户保护"];
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];//左边的按钮
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.changeTag = 0;
    [self.view addSubview:self.protectTableView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeSafe) name:@"changeSafe" object:nil];
    
    
}
//关闭帐户保护的通知
- (void)changeSafe{
    self.changeTag = 0;
    [self findFingerMarkAction];
}
/**
 *  返回
 */
- (void)onClickLeftItem
{
    if (_strTag.intValue == 1) {
        
        NewSignVC *sign = [NewSignVC new];
        sign.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:sign animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
/**
 *关闭标签
 */
- (UILabel *)closeLabel{
    if(!_closeLabel){
        _closeLabel = [Factory CreateLabelWithTextColor:1 andTextFont:30 andText:@"关闭账号保护" addSubView:nil];
        _closeLabel.textColor = UIColorFromRGB(0xff5933);
    }
    return _closeLabel;
}
#pragma mark - 懒加载
- (UITableView *)protectTableView {
    
    if (_protectTableView == nil) {
        
        _protectTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _protectTableView.delegate = self;
        _protectTableView.dataSource = self;
        _protectTableView.scrollEnabled = NO;
        _protectTableView.separatorColor = SeparatorColor;
        _protectTableView.backgroundColor = backGroundColor;
        
        _protectTableView.tableFooterView = [UIView new];
    }
    
    
    return _protectTableView;
}
/**
 *tableView自定义的头部视图的懒加载
 */
- (UIView *)headerView{
    if(!_headerView){
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 266*m6Scale)];
        _headerView.backgroundColor = backGroundColor;
        //账户安全图标
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"anquan"]];
        [_headerView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(58*m6Scale);
            make.centerX.mas_equalTo(_headerView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(100*m6Scale, 100*m6Scale));
        }];
        //账户安全标题
        UILabel *titleLabel = [Factory CreateLabelWithTextColor:0.3 andTextFont:26 andText:@"设置账户保护，让您的账户更安全" addSubView:_headerView];
        titleLabel.textColor = UIColorFromRGB(0x393939);
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(imgView.mas_bottom).offset(20*m6Scale);
            make.centerX.mas_equalTo(_headerView.mas_centerX);
        }];
    }
    return _headerView;
}

//指纹密码图标
- (UIImageView *)fingerView {
    
    
    if (_fingerView == nil) {
        
        
        _fingerView = [[UIImageView alloc] init];
    }
    
    return _fingerView;
}
//手势密码图标
- (UIImageView *)gestureView {
    
    if (_gestureView == nil) {
        
        _gestureView = [[UIImageView alloc] init];
    }
    
    return _gestureView;
}

#pragma mark - tableView代理方法

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section) {
        NSString *str = @"UITableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
        }
        cell.tag = 300;
        cell.selectionStyle = NO;
        [cell.contentView addSubview:self.closeLabel];
        [self.closeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(cell.contentView.mas_centerY);
            make.centerX.mas_equalTo(cell.contentView.mas_centerX);
        }];
        if ([[HCJFNSUser stringForKey:@"gestureLock"] isEqualToString:@"YES"] || [[HCJFNSUser stringForKey:@"fingerSwitch"] isEqualToString:@"YES"]) {
            cell.hidden = NO;
        }else{
            cell.hidden = YES;
        }
        
        return cell;
    }else{
        NSString *reuse = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuse];
        }
        NSArray *iconArr = @[@"zhiwen", @"shoushi"];
        NSArray *textArr = @[@"TouchID指纹密码", @"手势密码"];
        cell.imageView.image = [UIImage imageNamed:iconArr[indexPath.row]];
        cell.textLabel.text = textArr[indexPath.row];
        cell.selectionStyle = NO;
        //右边图标
        if (indexPath.row) {
            [cell addSubview:self.gestureView];
            [self.gestureView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-40*m6Scale);
                make.centerY.mas_equalTo(cell.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(40*m6Scale, 40*m6Scale));
            }];
        }else{
            [cell addSubview:self.fingerView];
            [self.fingerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-40*m6Scale);
                make.centerY.mas_equalTo(cell.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(40*m6Scale, 40*m6Scale));
            }];
        }
        
        
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100 * m6Scale;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 2;
    }else {
        
        return 1;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section) {
        return 0.01;
    }else{
        return 40*m6Scale;
    }
}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section) {
        return nil;
    }else{
        return self.headerView;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section) {
        return 0.01;
    }else{
        return 266*m6Scale;
    }
}
#pragma mark -didSelectRowAtIndexPath
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section) {
        NSLog(@"关闭账号保护");
        self.isCloseProtect = YES;
        //当用户需要关闭账号保护的时候，需要判断用户关闭哪个保护模式
        if ([[HCJFNSUser stringForKey:@"gestureLock"] isEqualToString:@"YES"]) {
            //此时用户要关闭手势密码验证
            [self gestureValueChanged];
        }else{
            //用户想要关闭TouchID指纹密码验证
            [self fingerSwitchValueChanged];
        }
    }else{
        self.isCloseProtect = NO;
        if (indexPath.row) {
            //当用户想要开启手势密码解锁时
            if ([[HCJFNSUser stringForKey:@"gestureLock"] isEqualToString:@"YES"]) {
                
            }else{
                //当点击手势密码，如果存在指纹密码self.changeTag = 1;否则self.changeTag = 0;
                if([[HCJFNSUser stringForKey:@"fingerSwitch"] isEqualToString:@"YES"])
                {
                    self.changeTag = 1;
                }
                else{
                    self.changeTag = 0;
                }
                [self gestureValueChanged];
            }
        }else{
            
            //当用户想要开启TouchID指纹密码验证
            if ([[HCJFNSUser stringForKey:@"fingerSwitch"] isEqualToString:@"YES"]) {
                
            }else{
                [self fingerSwitchValueChanged];
            }
        }
    }
}

/**
 *TouchID指纹密码
 */
- (void)fingerSwitchValueChanged{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *gesture = [user objectForKey:@"gestureLock"];
    
    if ([gesture isEqualToString:@"YES"]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:TitleMes message:@"您已开启手势密码，若选择开启指纹密码，则会导致手势密码关闭" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //            已开启手势密码，若选择开启指纹密码，则会导致手势密码关闭，开启指纹密码前先关闭手势密码
            [DownLoadData postGestureExist:^(id obj, NSError *error) {
                
                NSLog(@"%@",obj);
                
                NSString *result = [NSString stringWithFormat:@"%@",obj[@"result"]];
                
                if ([result isEqualToString:@"1"]) {
                    //验证手势密码
                    LockTestViewController *lockVC = [[LockTestViewController alloc] init];
                    lockVC.isCloseProtect = NO;
                    lockVC.tag = 5;
                    [self presentViewController:lockVC animated:YES completion:nil];
                    
                }else {
                    [self findFingerMarkAction];
                    
                }
                
            } userId:[user objectForKey:@"userId"]];
            // [self findFingerMarkAction];
            
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
    }else {
        
        [self findFingerMarkAction];
    }
}
/**
 *手势密码
 */
- (void)gestureValueChanged{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    NSString *finger = [user objectForKey:@"fingerSwitch"];
    GestureViewController *gestureVC = [[GestureViewController alloc] init];
    
    gestureVC.hidesBottomBarWhenPushed = YES;
    
    //判断用户点击  是为了关闭手势密码还是切换到TouchID指纹密码
    if ([finger isEqualToString:@"YES"]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您已开启指纹密码，若选择开启手势密码，则会导致指纹密码关闭" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if (self.changeTag == 1) {//如果已经存在指纹密码，要切换手势密码，必须先验证指纹
                [self findFingerMarkAction];
            }
            else{
                [DownLoadData postGestureExist:^(id obj, NSError *error) {
                    
                    NSLog(@"%@",obj);
                    
                    NSString *result = [NSString stringWithFormat:@"%@",obj[@"result"]];
                    
                    if ([result isEqualToString:@"1"]) {
                        //验证手势密码
                        LockTestViewController *lockVC = [[LockTestViewController alloc] init];
                        lockVC.isCloseProtect = self.isCloseProtect;
                        [self presentViewController:lockVC animated:YES completion:nil];
                        
                    }else {
                        [self.navigationController pushViewController:gestureVC animated:YES];
                        
                    }
                    
                } userId:[user objectForKey:@"userId"]];
            }
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }else {
        //关闭手势密码
        //查看手势密码是否存在
        [DownLoadData postGestureExist:^(id obj, NSError *error) {
            
            NSLog(@"%@",obj);
            
            NSString *result = [NSString stringWithFormat:@"%@",obj[@"result"]];
            
            if ([result isEqualToString:@"1"]) {
                //验证手势密码
                LockTestViewController *lockVC = [[LockTestViewController alloc] init];
                lockVC.isCloseProtect = self.isCloseProtect;
                [self presentViewController:lockVC animated:YES completion:nil];
            }else {
                [self.navigationController pushViewController:gestureVC animated:YES];
                
            }
            
        } userId:[user objectForKey:@"userId"]];
    }
}
/**
 指纹密码
 */
- (void)findFingerMarkAction{
    
    LAContext *clip = [[LAContext alloc] init];
    //    clip.localizedFallbackTitle = @"使用手势密码";
    NSError *hi = nil;
    NSString *hihihihi = @"使用指纹密码";
    if (self.changeTag == 1) {
        hihihihi = @"验证指纹密码";
    }
    else{
        hihihihi = @"使用指纹密码";
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    //TouchID是否存在
    if ([clip canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&hi]) {
        //TouchID开始运作
        [clip evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:hihihihi reply:^(BOOL succes, NSError *error)
         {
             
             if (succes) {
                 //验证通过
                 NSLog(@"验证通过");
                 
                 if(self.isCloseProtect){
                     
                     [user setValue:@"NO" forKey:@"fingerSwitch"];
                     [user setValue:@"NO" forKey:@"gestureLock"];
                     [user synchronize];
                     UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"账号保护已关闭" preferredStyle:UIAlertControllerStyleAlert];
                     
                     [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                         self.gestureView.image = [UIImage imageNamed:@""];
                         self.fingerView.image = [UIImage imageNamed:@""];
                         [self.protectTableView reloadData];
                         [DownLoadData postChangeSystemSetting:^(id obj, NSError *error) {
                             
                         } userId:[user objectForKey:@"userId"] gesture:@"0" touchID:@"0" accountProtect:@"0"];
                     }]];
                     [self presentViewController:alert animated:YES completion:nil];
                     
                 }else{
                     if (self.changeTag==1) {
                         [DownLoadData postGestureExist:^(id obj, NSError *error) {
                             
                             NSLog(@"%@",obj);
                             
                             NSString *result = [NSString stringWithFormat:@"%@",obj[@"result"]];
                             
                             if ([result isEqualToString:@"1"]) {
                                 //验证手势密码
                                 LockTestViewController *lockVC = [[LockTestViewController alloc] init];
                                 lockVC.isCloseProtect = self.isCloseProtect;
                                 [self presentViewController:lockVC animated:YES completion:nil];
                                 
                             }else {
                                 GestureViewController *gestureVC = [[GestureViewController alloc] init];
                                 [self.navigationController pushViewController:gestureVC animated:YES];
                                 
                             }
                             
                         } userId:[user objectForKey:@"userId"]];
                     }
                     else{
                         NSString *fingerStr;
                         fingerStr = @"YES";
                         //储存指纹密码
                         [user setValue:fingerStr forKey:@"fingerSwitch"];
                         [user synchronize];
                         //将删除本地手势密码记录
                         [user removeObjectForKey:@"gestureLock"];
                         [user synchronize];
                         
                         UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"指纹密码设置成功" preferredStyle:UIAlertControllerStyleAlert];
                         
                         [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                             self.gestureView.image = [UIImage imageNamed:@""];
                             self.fingerView.image = [UIImage imageNamed:@"kaiqi"];
                             [self.protectTableView reloadData];
                             //指纹的状态值不能存在服务器，只能存在本地
                             [DownLoadData postChangeSystemSetting:^(id obj, NSError *error) {
                                 
                             } userId:[user objectForKey:@"userId"] gesture:[NSString stringWithFormat:@"%@",[NSNumber numberWithBool:[[user objectForKey:@"gestureLock"]boolValue]]] touchID:@"0" accountProtect:@"1"];
                         }]];
                         
                         [self presentViewController:alert animated:YES completion:nil];
                     }
                 }
             }
             else
             {
                 
                 UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"指纹密码验证失败" preferredStyle:UIAlertControllerStyleAlert];
                 
                 [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                     
                     NSUserDefaults *user = HCJFNSUser;
                     //存储到本地的数据在退出登录的时候删除掉
                     NSArray *array = @[@"result",@"userId",@"switchGesture",@"userIcon",@"gesturePassword",@"fingerSwitch",@"gestureLock",@"userToken",@"bidBankCard"];
                     UserDefaults(@"fail", @"sxyRealName")
                     for (int i = 0; i < array.count; i++) {
                         [user removeObjectForKey:array[i]];
                         [user synchronize];
                     }
                     //退出登录，需要注销网易七鱼
                     [[QYSDK sharedSDK] logout:^{
                         NewSignVC *signVC = [[NewSignVC alloc] init];
                         signVC.presentTag = @"1";
                         [self presentViewController:signVC animated:YES completion:nil];
                     }];
                 }]];
                 
                 [self presentViewController:alert animated:YES completion:nil];
                 
             }
         }];
    }
    else
    {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"设备尚不支持TouchID或您尚未开启设备的TouchID，请前往系统设置开启并设置TouchID" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
        //没有开启TouchID设备自行解决
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    NSString *gesture = [user objectForKey:@"gestureLock"];
    NSString *finger = [user objectForKey:@"fingerSwitch"];
    NSLog(@"%@",gesture);
    //    //判断是否开启手势密码
    if ([gesture isEqualToString:@"YES"]) {
        
        self.gestureView.image = [UIImage imageNamed:@"kaiqi"];
        
    }else {
        
        self.gestureView.image = [UIImage imageNamed:@""];
    }
    
    if ([finger isEqualToString:@"YES"]) {
        
        self.fingerView.image = [UIImage imageNamed:@"kaiqi"];
        
    }else {
        self.fingerView.image = [UIImage imageNamed:@""];
    }
    
    
    [self.protectTableView reloadData];
    
    [Factory hidentabar];
    [Factory navgation:self];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
