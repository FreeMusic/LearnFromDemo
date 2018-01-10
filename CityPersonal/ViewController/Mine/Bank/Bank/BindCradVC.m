//
//  BindCradVC.m
//  CityJinFu
//
//  Created by xxlc on 16/8/23.
//  Copyright © 2016年 yunfu. All rights reserved.
//

#import "BindCradVC.h"
#import "ProtocolVC.h"
#import "AppDelegate.h"
#import "GXJButton.h"
#import "HelpTableViewController.h"

@interface BindCradVC ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, APNumberPadDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *nameText;//姓名
@property (nonatomic, strong) UITextField *IdCardText;//身份证号
@property (nonatomic, strong) UITextField *bankNumText;//银行卡号
@property (nonatomic, strong) UILabel *hintLabel;//提示文本
@property (nonatomic, strong) GXJButton *submintBtn;//提交按钮
@property (nonatomic, strong) UILabel *protocolLabel;//协议文本
@property (nonatomic, strong) UIImageView *hintImage;//提示图片
@property (nonatomic, copy) NSString *realNameStatus; //是否实名认证
@property (nonatomic, copy) NSString *nameStr; //真实姓名
@property (nonatomic, copy) NSString *IDCardNum; //身份证信息
@property (nonatomic, strong) UINavigationBar *QYnavBar;

@end

@implementation BindCradVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backGroundColor;
    //标题
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"实名验证"];
    //导航设置
    self.navigationController.navigationBar.translucent = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    //左边按钮
    UIButton *leftButton = [Factory addLeftbottonToVC:self];//左边的按钮
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    //右边按钮
    UIButton *rightBtn = [Factory addRightbottonToVC:self];
    [rightBtn addTarget:self action:@selector(onClickRightItem) forControlEvents:UIControlEventTouchUpInside];
    //tableView
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = SeparatorColor;
    [self.view addSubview:_tableView];
    
}
/**
 *  返回
 */
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITextField *)nameText {
    
    if (_nameText == nil) {
        
        _nameText = [[UITextField alloc] init];
    }
    
    return _nameText;
}

- (UITextField *)IdCardText {
    
    if (_IdCardText == nil) {
        
        _IdCardText = [[UITextField alloc] init];
    }
    
    return _IdCardText;
}
/**
 *  右边的按钮
 */
- (void)onClickRightItem
{
    
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"在线客服" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([defaults objectForKey:@"userId"]) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.label.text = NSLocalizedString(@"连接中...", @"HUD loading title");
                //用户个人信息
                [DownLoadData postUserInformation:^(id obj, NSError *error) {
                    
                    NSLog(@"%@-------",obj);
                    
                    if (obj[@"usableCouponCount"]) {
                        
                        [HCJFNSUser setValue:obj[@"usableCouponCount"] forKey:@"Red"];
                    }
                    if (obj[@"usableTicketCount"]) {
                        [HCJFNSUser setValue:obj[@"usableTicketCount"] forKey:@"Ticket"];
                        
                    }
                    if ([obj[@"identifyCard"] isKindOfClass:[NSNull class]] || obj[@"identifyCard"] == nil) {
                        [HCJFNSUser setValue:@"1" forKey:@"IdNumber"];
                    }else{
                        [HCJFNSUser setValue:obj[@"identifyCard"] forKey:@"IdNumber"];
                    }
                    NSArray *array = obj[@"accountBankList"];
                    if ([array count] == 0) {
                        [HCJFNSUser setValue:@"1" forKey:@"cardNo"];
                    }else{
                        
                        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            [HCJFNSUser setValue:obj[@"cardNo"] forKey:@"cardNo"];
                        }];
                    }
                    [HCJFNSUser setValue:[obj[@"accountBankList"] firstObject][@"realname"] forKey:@"realname"];//姓名
                    [HCJFNSUser synchronize];
                    [hud setHidden:YES];
                    //在线客服
                    QYSessionViewController *sessionViewController = [Factory jumpToQY];
                    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:sessionViewController];
                    if (iOS11) {
                        self.QYnavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, kScreenWidth, NavigationBarHeight)];
                    }else{
                        self.QYnavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, NavigationBarHeight)];
                    }
                    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"汇诚金服"];
                    TitleLabelStyle *titleLabel = [[TitleLabelStyle alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
                    [titleLabel titleLabel:@"汇诚金服" color:[UIColor blackColor]];
                    navItem.titleView = titleLabel;
                    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fanghui"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
                    
                    left.tintColor = [UIColor blackColor];
                    [self.QYnavBar pushNavigationItem:navItem animated:NO];
                    [navItem setLeftBarButtonItem:left];
                    //    [navItem setRightBarButtonItem:right];
                    [navi.view addSubview:self.QYnavBar];
                    
                    [self presentViewController:navi animated:YES completion:nil];
                } userId:[HCJFNSUser objectForKey:@"userId"]];
            }else{
                [Factory alertMes:@"请先登录"];
            }
            
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"客服电话" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //呼叫客服
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:TitleMes message:@"客服时间:9:00-17:30\n400-0571-909" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                NSString *str = @"tel://400-0571-909";
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            }]];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"帮助中心" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            //帮助中心
            HelpTableViewController *help = [HelpTableViewController new];
            [self.navigationController pushViewController:help animated:YES];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil]];
        
        [self presentViewController:alert animated:YES completion:nil];

    
}
#pragma mark - 网易七鱼返回
- (void)onBack:(UINavigationItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -numberOfSections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
#pragma mark -cellForRow
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *string = HCJF;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"姓名";
            
            self.nameText.text = self.nameStr;
            self.nameText.delegate = self;
            NSLog(@"%@",self.nameStr);
            _nameText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入姓名" attributes:@{NSForegroundColorAttributeName: titleColor}];
            [_nameText setValue:[UIFont boldSystemFontOfSize:32*m6Scale] forKeyPath:@"_placeholderLabel.font"];
            [cell addSubview:_nameText];
            [_nameText mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView.mas_left).offset(220*m6Scale);
                make.top.equalTo(cell.contentView.mas_top).offset(15*m6Scale);
                make.size.mas_equalTo(CGSizeMake(kScreenWidth-240*m6Scale, 80*m6Scale));
            }];
        }
        else{
            cell.textLabel.text = @"身份证号";
            
            self.IdCardText.text = self.IDCardNum;
            self.IdCardText.delegate = self;
            self.IdCardText.tag = 10;
            _IdCardText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入身份证号" attributes:@{NSForegroundColorAttributeName: titleColor}];
            [_IdCardText setValue:[UIFont boldSystemFontOfSize:32*m6Scale] forKeyPath:@"_placeholderLabel.font"];
            self.IdCardText.keyboardType = UIKeyboardTypeDecimalPad;//键盘样式
            //定制的键盘
            KeyBoard *key = [[KeyBoard alloc]init];
            UIView *clip = [key keyBoardview];
            [key.doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
            
            self.IdCardText.inputAccessoryView = clip;
            self.IdCardText.inputView = ({
                APNumberPad *numberPad = [APNumberPad numberPadWithDelegate:self];
                
                [numberPad.leftFunctionButton setTitle:@"X" forState:UIControlStateNormal];
                numberPad.leftFunctionButton.titleLabel.adjustsFontSizeToFitWidth = YES;
                numberPad;
            });

            [cell addSubview:_IdCardText];
            [_IdCardText mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView.mas_left).offset(220*m6Scale);
                make.top.equalTo(cell.contentView.mas_top).offset(15*m6Scale);
                make.size.mas_equalTo(CGSizeMake(kScreenWidth-240*m6Scale, 80*m6Scale));
            }];
        }
    }
    else{
        
    }
    cell.textLabel.textColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100*m6Scale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 18*m6Scale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 300 * m6Scale;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
   
    if (section == 0) {
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 160 * m6Scale)];
    //提示
    _hintImage = [UIImageView new];
    _hintImage.image = [UIImage imageNamed:@"4"];
    [footView addSubview:_hintImage];
    [_hintImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footView.mas_left).offset(44*m6Scale);
        make.top.equalTo(footView.mas_top).offset(45*m6Scale);
        make.size.mas_equalTo(CGSizeMake(30*m6Scale, 30*m6Scale));
    }];
//    //提示文本
//    _hintLabel = [UILabel new];
//    _hintLabel.numberOfLines = 0;
//    _hintLabel.text = @"为了保护账户安全，需要保证姓名、身份证、银行\n卡开户人为同一人";
//    _hintLabel.textColor = [UIColor lightGrayColor];
//    _hintLabel.font = [UIFont systemFontOfSize:28*m6Scale];
//    [footView addSubview:_hintLabel];
//    [_hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_hintImage.mas_right).offset(10*m6Scale);
//        make.right.equalTo(footView.mas_right).offset(-30*m6Scale);
//        make.top.equalTo(footView.mas_top).offset(32*m6Scale);
//        make.height.equalTo(@(80*m6Scale));
//    }];
    //提交按钮
    _submintBtn = [GXJButton buttonWithType:UIButtonTypeCustom];
    [_submintBtn setTitle:@"提交" forState:UIControlStateNormal];
    [_submintBtn addTarget:self action:@selector(submintBtn:) forControlEvents:UIControlEventTouchUpInside];
    _submintBtn.time = 3.0;
    _submintBtn.layer.cornerRadius = 5;
    [footView addSubview:self.submintBtn];
    [_submintBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footView.mas_left).offset(44*m6Scale);
        make.right.equalTo(footView.mas_right).offset(-44*m6Scale);
        make.top.equalTo(footView.mas_top).offset(40*m6Scale);
        make.height.equalTo(@(90*m6Scale));
    }];
    //协议
    _protocolLabel = [UILabel new];
    _protocolLabel.text = @"为保护账户安全，请保证姓名，\n身份证信息一致";
    _protocolLabel.numberOfLines = 0;
    _protocolLabel.textColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    _protocolLabel.textAlignment = NSTextAlignmentCenter;
    _protocolLabel.font = [UIFont systemFontOfSize:30*m6Scale];
    _protocolLabel.userInteractionEnabled = YES;
//    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:_protocolLabel.text attributes:nil];
//    [att addAttribute:NSForegroundColorAttributeName value:buttonColor range:[_protocolLabel.text rangeOfString:@"《先锋支付托管账户服务协议》"]];
//        _protocolLabel.attributedText = att;
//    UITapGestureRecognizer * singleRecognizer =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resgister:)];//手势
//    singleRecognizer.numberOfTapsRequired = 1;
//    [self.protocolLabel addGestureRecognizer:singleRecognizer];
    [footView addSubview:_protocolLabel];
    [_protocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(footView.mas_centerX);
        make.top.equalTo(_submintBtn.mas_bottom).offset(20*m6Scale);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth - 100*m6Scale, 90*m6Scale));
    }];
       return footView;
    }
    else{
        return nil;
    }
    
}
/**
 *  提交按钮点击事件
 */
//- (void)submintBtn:(UIButton *)sender {

//    [DownLoadData postApplyRecharge:^(id obj, NSError *error) {
//        NSLog(@"%@", obj[@"data"]);
//    } userId:@"" amount:@"" bankId:@"" password:@"" mcryptKey:@""];
    
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    // Set the label text.
//    hud.label.text = NSLocalizedString(@"加载中...", @"HUD loading title");
//    
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    NSString *userId = [user objectForKey:@"userId"];
//    if (_nameText.text.length > 0 && _nameText.text != nil  && _IdCardText.text.length == 18) {
//        //判断是否实名
//        if ([self.realNameStatus isEqualToString:@"0"]) {
//
//            [DownLoadData postRealName:^(id obj, NSError *error) {
//                [hud hideAnimated:YES];
//                //根据返回结果判断是否开户成功
//                if ([obj[@"result"] isEqualToString:@"fail"]) {
//                    
//                    NSString *message = obj[@"messageText"];
//                    
//                    if (obj[@"messageText"] == nil) {
//                        
//                        message = Message;
//                    }
//                    
//                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
//                    
//                    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
//                    
//                    [self presentViewController:alert animated:YES completion:nil];
//                    
//                }else {
//                    //返回结果成功，调加签接口
//                    [DownLoadData postSignature:^(id obj, NSError *error) {
//                        [hud hideAnimated:YES];
//                        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
//
//                        [dic setValue:obj[@"sign"] forKey:@"sign"];
//                        [dic setValue:moeyKey forKey:@"merchantId"];
//                        [dic setValue:[user objectForKey:@"userId"] forKey:@"userId"];
//
//                        [UcfPaymentServiceSDK authWithRootVC:self params:[dic copy] successBlock:^(NSDictionary *params) {
//                            
//                            NSLog(@"success:%@",params);
//                            
//                            if ([params[@"respMsg"] isEqualToString:@"认证成功"]) {
//                                [DownLoadData postAddBank:^(id obj, NSError *error) {
//
//                                    NSString *result = obj[@"result"];
//                                    
//                                    if ([result isEqualToString:@"success"]) {
//                                        
//                                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"恭喜您，绑卡成功" preferredStyle:UIAlertControllerStyleAlert];
//                                        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                                            [self.navigationController popViewControllerAnimated:YES];
//                                        }]];
//                                        
//                                        [self presentViewController:alert  animated:YES completion:nil];
//                                    }else {
//                                        
//                                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:obj[@"messageText"] preferredStyle:UIAlertControllerStyleAlert];
//                                        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                                            [self.navigationController popViewControllerAnimated:YES];
//                                        }]];
//                                        
//                                        [self presentViewController:alert  animated:YES completion:nil];
//                                    }
//                                    
//                                } userId:userId];
//                                
//                            }else {
//                                
//                            }
//                            
//                        } failBlock:^(NSDictionary *params) {
//                            
////                            NSLog(@"fail:%@",params);
//                        }];
//                    } userId:userId];
//                }
//            } userId:userId realName:_nameText.text identifyCard:_IdCardText.text];
//            
//        }else if ([self.realNameStatus isEqualToString:@"1"]) {
//            
//            //返回结果成功，调加签接口
//            [DownLoadData postSignature:^(id obj, NSError *error) {
//                
//                [hud hideAnimated:YES];
//                NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
////                NSLog(@"%@",obj);
//                [dic setValue:obj[@"sign"] forKey:@"sign"];
//                [dic setValue:moeyKey forKey:@"merchantId"];
//                [dic setValue:[user objectForKey:@"userId"] forKey:@"userId"];
////                NSLog(@"%@",userId);
//                [UcfPaymentServiceSDK authWithRootVC:self params:[dic copy] successBlock:^(NSDictionary *params) {
//                    
//                    NSLog(@"success:%@",params);
//                    
//                    if ([params[@"respMsg"] isEqualToString:@"认证成功"]) {
//                        [DownLoadData postAddBank:^(id obj, NSError *error) {
//                            
//                            NSString *result = obj[@"result"];
//                            
//                            if ([result isEqualToString:@"success"]) {
//                                
//                                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"恭喜您，绑卡成功" preferredStyle:UIAlertControllerStyleAlert];
//                                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                                    [self.navigationController popViewControllerAnimated:YES];
//                                }]];
//                                
//                                [self presentViewController:alert  animated:YES completion:nil];
//                            }else {
//                                
//                                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"绑卡失败" preferredStyle:UIAlertControllerStyleAlert];
//                                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                                    [self.navigationController popViewControllerAnimated:YES];
//                                }]];
//                                
//                                [self presentViewController:alert  animated:YES completion:nil];
//                            }
//                            
//                        } userId:userId];
//                        
//                    }
//                    
//                    
//                } failBlock:^(NSDictionary *params) {
//                    
//                    NSLog(@"fail:%@",params);
//                }];
//                
//            } userId:userId];
//        }else {
//            
//            
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"系统繁忙，请稍后重试" preferredStyle:UIAlertControllerStyleAlert];
//            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                
//                [hud hideAnimated:YES];
//                [self.navigationController popViewControllerAnimated:YES];
//            }]];
//            
//            [self presentViewController:alert animated:YES completion:nil];
//        }
//        
//    }else {
//        [hud hideAnimated:YES];
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"信息尚未填写完整或格式错误" preferredStyle:UIAlertControllerStyleAlert];
//        
//        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
//        [self presentViewController:alert animated:YES completion:nil];
//    }
//}
///**
// *  服务协议
// */
//- (void)resgister:(UITapGestureRecognizer *)sender
//{
////    ProtocolVC *protocol = [ProtocolVC new];
////    protocol.hidesBottomBarWhenPushed = YES;
////    protocol.strTag = @"1";
////    [self.navigationController pushViewController:protocol animated:YES];
////    
////    NSLog(@"UITapGestureRecognizer");
//}
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [Factory hidentabar];//隐藏控制器
    [Factory navgation:self];//导航的处理
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    NSString *userId = [user objectForKey:@"userId"];
    
    [DownLoadData postrealName:^(id obj, NSError *error) {
        
        NSString *status = [NSString stringWithFormat:@"%@",obj[@"realnameStatus"]];
        
        NSLog(@"%@",obj);
        
        self.realNameStatus = status;
        
        if ([status isEqualToString:@"1"]) {
            
            self.IdCardText.userInteractionEnabled = NO;
            self.nameText.userInteractionEnabled = NO;
            self.nameStr = obj[@"realname"];
            self.IDCardNum = obj[@"identifyCard"];
            [self.tableView reloadData];
        }
    } userId:userId];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
}
/**
 *  第一响应者
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.nameText) {
        return [self.nameText resignFirstResponder];
    }
    else{
        return [self.IdCardText resignFirstResponder];
    }
}
/**
 *  文本框的内容是否符合要求
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    UITextField *text = (UITextField *)[self.view viewWithTag:10];
    if (text == textField) {
        if (range.location >= 18) {
            return NO;
        }
        return YES;
    }
    else{

        return YES;
    }
}
/**
 *  用户点击空白区域键盘的隐藏
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.nameText resignFirstResponder];
    [self.IdCardText resignFirstResponder];
}
/**
 *  键盘消失
 */
- (void)doneButton:(UIButton *)button {
    
    [self.view endEditing:YES];
    
}
#pragma mark - APNumberPadDelegate

- (void)numberPad:(APNumberPad *)numberPad functionButtonAction:(UIButton *)functionButton textInput:(UIResponder<UITextInput> *)textInput {
   
        [textInput insertText:@"X"];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
