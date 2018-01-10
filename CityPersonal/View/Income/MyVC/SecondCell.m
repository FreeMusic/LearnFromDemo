//
//  SecondCell.m
//  CityJinFu
//
//  Created by xxlc on 17/5/22.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "SecondCell.h"
#import "MywelfareVC.h"
#import "AutoOpenViewVC.h"
#import "NewAutoVC.h"
#import "BindCradVC.h"
#import "CalendarVC.h"
#import "AutoBidSettingViewController.h"
#import "ActivityVC.h"
#import "MyOrderVC.h"
#import "ScanIdentityVC.h"
#import "MyBillVC.h"
#import "InviteFriedsDetailsVC.h"
#import "ActivityCenterVC.h"
#import "MoneyPlanVC.h"
#import "VipVC.h"
#import "BidCardFirstVC.h"
#import "HelpTableViewController.h"
#import "NewMyBillVC.h"
#import "NewInviteFriendVC.h"

@implementation SecondCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatView];
    }
    return self;
}
/**
 创建布局
 */
- (void)creatView{
    NSArray *array = @[@"投资日历",@"自动投标",@"商城订单",@"我的福利", @"我的账单", @"邀请好友", @"风险评估", @"锁投加息", @"会员中心", @"联系客服", @"每日签到"];
    NSArray *picArr = @[@"rili",@"myzidongtoubiao",@"citydingdan",@"fuli", @"wodezhangdan", @"yaoqinghaoyou", @"fenxianpingu", @"licaijihua", @"huiyuanzhongxing", @"lianxikefu", @"meiriqiandao"];
    for (int i = 0; i < array.count; i ++) {
        UILabel *label = [UILabel new];
        label.text = array[i];
        label.font = [UIFont systemFontOfSize:30*m6Scale];
        label.textColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        label.textAlignment = NSTextAlignmentCenter;
        _button = [SXYButton buttonWithType:UIButtonTypeCustom];
        _button.tag = 100 + i;
        if (i == 3) {
            UIView *point = [UIView new];
            
            point.backgroundColor = [UIColor redColor];
            point.layer.cornerRadius = 5*m6Scale;
            point.layer.masksToBounds = YES;
            point.tag = 1000;
            
            [_button addSubview:point];
            
            [point mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(20*m6Scale);
                make.right.mas_equalTo(-50*m6Scale);
                make.size.mas_equalTo(CGSizeMake(10*m6Scale, 10*m6Scale));
            }];
        }
        [_button addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
        [_button setImage:[UIImage imageNamed:picArr[i]] forState:UIControlStateNormal];
        
        _button.frame = CGRectMake((kScreenWidth / 4) * (i%4), 10*m6Scale+(i/4*200*m6Scale), kScreenWidth / 4, 100*m6Scale);
        label.frame = CGRectMake((kScreenWidth / 4) * (i%4), 115*m6Scale+(i/4*200*m6Scale), kScreenWidth / 4, 30*m6Scale);
        [self.contentView addSubview:label];
        [self.contentView addSubview:_button];
    }
}
/**
 中间的选择
 */
- (void)button:(UIButton *)sender{
    UIViewController *ctr = (UIViewController *)[self ViewController];
    switch (sender.tag) {
        case 100:{//投资日历
            CalendarVC *calendar = [CalendarVC new];
            [ctr.navigationController pushViewController:calendar animated:YES];
        }
            break;
        case 101:{//自动投标
            
            [self labelExample];//HUD
            //实名前查询老用户实名信息
            [DownLoadData postRealNameInformation:^(id obj, NSError *error) {
                //首先根据realnameStatus该字段判断用户是否实名过
                NSString *status = [NSString stringWithFormat:@"%@", obj[@"realnameStatus"]];
                NSString *realName = [NSString stringWithFormat:@"%@", obj[@"realname"]];
                if (status.integerValue) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_hud hideAnimated:YES];
                    });
                    //用户实名过 提醒用户绑卡
                    [DownLoadData postGetBankByUserId:^(id obj, NSError *error) {
                        if ([obj[@"result"] isEqualToString:@"success"]) {
                            //跳转自动投标界面
                            AutoBidSettingViewController *autoVC = [AutoBidSettingViewController new];
                            [ctr.navigationController pushViewController:autoVC animated:YES];
                        }else{
                            [self alertByUserName:realName];
                        }
                    } userId:[HCJFNSUser stringForKey:@"userId"]];
                }else{
                    [_hud hideAnimated:YES];
                    NSString *realName = [NSString stringWithFormat:@"%@", obj[@"realname"]];
                    NSString *identifyCard = [NSString stringWithFormat:@"%@", obj[@"identifyCard"]];
                    NSString *realnameStatus = [NSString stringWithFormat:@"%@", obj[@"realnameStatus"]];
                    [self alertActionWithUserName:realName identifyCard:identifyCard status:realnameStatus VC:ctr];
//                    //提示绑卡
//                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:TitleMes message:@"您尚未实名，是否立刻去实名?" preferredStyle:UIAlertControllerStyleAlert];
//                    [_hud hideAnimated:YES];//HUD
//                    [alert addAction:[UIAlertAction actionWithTitle:@"不,谢谢" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                    }]];
//                    
//                    [alert addAction:[UIAlertAction actionWithTitle:@"立即前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                        //当用户想要去实名认证的时候.需要获得用户的名字和身份证号
//                        NSString *identifyCard = [NSString stringWithFormat:@"%@", obj[@"identifyCard"]];
//                        NSString *realnameStatus = [NSString stringWithFormat:@"%@", obj[@"realnameStatus"]];
//                        ScanIdentityVC *tempVC = [ScanIdentityVC new];
//                        tempVC.userName = realName;//用户名字
//                        tempVC.identifyCard = identifyCard;//用户身份证号
//                        tempVC.realnameStatus = realnameStatus;//用户实名的状态 0未实名 1实名
//                        [ctr.navigationController pushViewController:tempVC animated:YES];
//                    }]];
//                    
//                    [ctr presentViewController:alert animated:YES completion:nil];
                }
            } userId:[HCJFNSUser stringForKey:@"userId"]];
        }
            break;
        case 102:{//商城
            [self labelExample];//HUD
            //实名前查询老用户实名信息
            [DownLoadData postRealNameInformation:^(id obj, NSError *error) {
                //首先根据realnameStatus该字段判断用户是否实名过
                NSString *status = [NSString stringWithFormat:@"%@", obj[@"realnameStatus"]];
                if (status.integerValue) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_hud hideAnimated:YES];
                    });
                    MyOrderVC *iphone = [MyOrderVC new];
                    [ctr.navigationController pushViewController:iphone animated:YES];
                }else{
                    [_hud hideAnimated:YES];
                    //提示绑卡
//                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:TitleMes message:@"您尚未实名，是否立刻去实名?" preferredStyle:UIAlertControllerStyleAlert];
//                    [_hud hideAnimated:YES];//HUD
//                    [alert addAction:[UIAlertAction actionWithTitle:@"不,谢谢" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                    }]];
//                    
//                    [alert addAction:[UIAlertAction actionWithTitle:@"立即前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        //当用户想要去实名认证的时候.需要获得用户的名字和身份证号
                        NSString *realName = [NSString stringWithFormat:@"%@", obj[@"realname"]];
                        NSString *identifyCard = [NSString stringWithFormat:@"%@", obj[@"identifyCard"]];
                        NSString *realnameStatus = [NSString stringWithFormat:@"%@", obj[@"realnameStatus"]];
                        [self alertActionWithUserName:realName identifyCard:identifyCard status:realnameStatus VC:ctr];
//                        ScanIdentityVC *tempVC = [ScanIdentityVC new];
//                        tempVC.userName = realName;//用户名字
//                        tempVC.identifyCard = identifyCard;//用户身份证号
//                        tempVC.realnameStatus = realnameStatus;//用户实名的状态 0未实名 1实名
//                        [ctr.navigationController pushViewController:tempVC animated:YES];
                    //}]];
                    
                    //[ctr presentViewController:alert animated:YES completion:nil];
                }
            } userId:[HCJFNSUser stringForKey:@"userId"]];
        }
            break;
        case 103:{//我的福利
            MywelfareVC *myWel = [MywelfareVC new];
            
            myWel.coupon = _coupon;//红包
            myWel.ticket = _ticket;//卡券
            myWel.experienceGold = _experienceGold;//体验金
            
            [ctr.navigationController pushViewController:myWel animated:YES];
        }
            break;
        case 104:{//我的账单
//            MyBillVC *tempVC = [MyBillVC new];
//            [ctr.navigationController pushViewController:tempVC animated:YES];
            
            NewMyBillVC *tempVC = [NewMyBillVC new];
            [ctr.navigationController pushViewController:tempVC animated:YES];
        
        }
            break;
        case 105:{//邀请好友
            NewInviteFriendVC *tempVC = [NewInviteFriendVC new];
            [ctr.navigationController pushViewController:tempVC animated:YES];
        }
            break;
        case 106:{//风险评估
            ActivityCenterVC *tempVC = [ActivityCenterVC new];
            tempVC.tag = 3;
            tempVC.urlName = @"风险评估";
            [ctr.navigationController pushViewController:tempVC animated:YES];
        }
            break;
        case 107:{//理财计划
            MoneyPlanVC *tempVC = [MoneyPlanVC new];
            [ctr.navigationController pushViewController:tempVC animated:YES];
        }
            break;
        case 108:{//会员中心
            VipVC *tempVC = [VipVC new];
            [ctr.navigationController pushViewController:tempVC animated:YES];
        }
            break;
        case 109:{//联系客服
            //呼叫客服
            [self helpCenter];
        }
            break;
        case 110:{//每日签到
            [DownLoadData postGetMemberPicture:^(id obj, NSError *error) {
                if ([obj[@"result"] isEqualToString:@"success"]) {
                    [Factory addAlertToVC:ctr withMessage:obj[@"remark"]];
                }else{
                    [Factory addAlertToVC:ctr withMessage:obj[@"messageText"]];
                }
            } userId:[HCJFNSUser stringForKey:@"userId"]];
        }
            break;
            
        default:
            break;
    }
}
/**
 右边按钮，帮助中心,客服电话
 */
- (void)helpCenter{
    UIViewController *ctr = (UIViewController *)[self ViewController];
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertView addAction:[UIAlertAction actionWithTitle:@"在线客服" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([defaults objectForKey:@"userId"]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:ctr.view animated:YES];
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
                
                [ctr presentViewController:navi animated:YES completion:nil];
                //[ctr.navigationController pushViewController:navi animated:YES];
            } userId:[HCJFNSUser objectForKey:@"userId"]];
        }
        else{
            [Factory alertMes:@"请先登录"];
        }
    }]];
    
    [alertView addAction:[UIAlertAction actionWithTitle:@"客服电话" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //呼叫客服
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:TitleMes message:@"客服时间:9:00-17:30\n400-0571-909" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSString *str = @"tel://400-0571-909";
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }]];
        
        [ctr presentViewController:alert animated:YES completion:nil];
        
    }]];
    
    [alertView addAction:[UIAlertAction actionWithTitle:@"帮助中心" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        HelpTableViewController *achieve = [HelpTableViewController new];
        [ctr.navigationController pushViewController:achieve animated:YES];
        
    }]];
    
    [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil]];
       [ctr presentViewController:alertView animated:YES completion:nil];
    
}
#pragma mark - 网易七鱼返回
- (void)onBack:(UINavigationItem *)sender
{
    UIViewController *ctr = (UIViewController *)[self ViewController];
    [ctr dismissViewControllerAnimated:YES completion:nil];
}
/**
 *  提示用户去开户
 */
- (void)alertActionWithUserName:(NSString *)userName identifyCard:(NSString *)identifyCard status:(NSString *)status VC:(UIViewController *)vc{
    self.openAlert = [[OpenAlertView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    [[UIApplication sharedApplication].keyWindow addSubview:self.openAlert];
    __weak typeof(self.openAlert) openSelf = self.openAlert;
    [self.openAlert setButtonAction:^(NSInteger tag) {
        [openSelf removeFromSuperview];
        if (tag == 0) {
            ScanIdentityVC *tempVC = [ScanIdentityVC new];
            tempVC.userName = userName;
            tempVC.identifyCard = identifyCard;
            tempVC.realnameStatus = status;
            [vc.navigationController pushViewController:tempVC animated:YES];
        }else if (tag == 2){
            
            MywelfareVC *tempVC = [MywelfareVC new];
            
            [vc.navigationController pushViewController:tempVC animated:YES];
            
        }
    }];
}
/**
 是否绑卡提示
 */
- (void)alertByUserName:(NSString *)name{
    UIViewController *ctr = (UIViewController *)[self ViewController];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:TitleMes message:@"您尚未绑卡，是否立刻绑定银行卡?" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"不,谢谢" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [ctr.navigationController popViewControllerAnimated:YES];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"立即前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //跳转至绑定银行卡页面
        BidCardFirstVC *tempVC = [BidCardFirstVC new];
        tempVC.userName = name;//用户真实姓名
        [ctr.navigationController pushViewController:tempVC animated:YES];
    }]];
    
    [ctr presentViewController:alert animated:YES completion:nil];
}
//HUD加载转圈
- (void)labelExample {
    
    UIViewController *ctr = (UIViewController *)[self ViewController];
    _hud = [MBProgressHUD showHUDAddedTo:ctr.view animated:YES];
    
    // Set the label text.
    //    _hud.label.text = NSLocalizedString(@"加载中...", @"HUD loading title");
    // You can also adjust other label properties if needed.
    // hud.label.font = [UIFont italicSystemFontOfSize:16.f];
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        sleep(10.);
    });
}
/**
 *  是否隐藏福利福利红点
 */
- (void)addWelfToPoint:(NSInteger)total{
    
    UIView *point = (UIView *)[self viewWithTag:1000];
    
    if (total) {
        
        point.hidden = NO;
        
    }else{
        
        point.hidden = YES;
        
    }
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
