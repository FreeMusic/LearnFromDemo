//
//  VipVC.m
//  CityJinFu
//
//  Created by xxlc on 17/6/27.
//  Copyright © 2017年 yunfu. All rights reserved.
//

#import "VipVC.h"
#import "ItemView.h"
#import "VipHeaderCell.h"
#import "VipBottomCell.h"
#import "MoreStrategyVC.h"
#import "VipClubModel.h"
#import "MoreStrategyModel.h"
#import "NewInviteFriendVC.h"
#import "AutoBidSettingViewController.h"
#import "PushView.h"
#import "VipEquityVC.h"
#import "IntegralShopVC.h"
#import "ScanIdentityVC.h"
#import "MywelfareVC.h"
#import "IphoneVC.h"
#import "PushImgView.h"
#import "ActivityCenterVC.h"

@interface VipVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UINavigationBar *QYnavBar;
@property (nonatomic, strong) VipClubModel *vipClubModel;//会员首页数据
@property (nonatomic, strong) NSMutableArray *dataArr;//会员中心推荐任务列表数组
@property (nonatomic, strong) PushImgView *pushView;//弹出视图
@property (nonatomic, strong) UIImageView *pushImg;//弹出图片
@property (nonatomic, strong) NSMutableArray *shopArr;//积分商品推荐数组

@end

@implementation VipVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backGroundColor;
    //标题
    [TitleLabelStyle addtitleViewToVC:self withTitle:@"会员俱乐部" color:[UIColor whiteColor]];
    //左边按钮
    UIButton *leftButton = [Factory addBlackLeftbottonToVC:self];//左边的按钮
    [leftButton addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    //右边按钮
    UIButton *rightBtn = [Factory addRightbottonToVC:self];
    [rightBtn addTarget:self action:@selector(helpCenter) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.tableView];
    //请求数据
    [self serverData];
    //接受让弹屏出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buttonClick:) name:@"MakePushView" object:nil];
}
/**
 懒加载tableView
 */
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -4-NavigationBarHeight,kScreenWidth, kScreenHeight+NavigationBarHeight) style:UITableViewStyleGrouped];
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.scrollEnabled = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.sectionFooterHeight = 0;
        _tableView.sectionHeaderHeight = 20*m6Scale;
        _tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
        
    }
    return _tableView;
}
/**
 *模型数组的懒加载
 */
- (NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
/**
 *积分商品推荐数组
 */
- (NSMutableArray *)shopArr{
    if(!_shopArr){
        _shopArr = [NSMutableArray array];
    }
    return _shopArr;
}
/**
 *请求数据
 */
- (void)serverData{
    //会员首页数据
    [DownLoadData postGetGradeAndIntegral:^(id obj, NSError *error) {
        _vipClubModel = [[VipClubModel alloc] initWithDictionary:obj];
        self.userMoney = [NSString stringWithFormat:@"%d", [_vipClubModel.yearAmount intValue]];//用户的财气值
        self.vipGrade = [NSString stringWithFormat:@"%1.f@", [_vipClubModel.memberGrade floatValue]];//会员等级
        self.userName = [NSString stringWithFormat:@"%@", _vipClubModel.userName];//用户名称
        //刷新tableView第一行数据 即头部数据(//刷新第1段第1行)
        NSIndexPath *indexPathA = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathA,nil] withRowAnimation:UITableViewRowAnimationNone];
    } userId:[HCJFNSUser stringForKey:@"userId"]];
    //会员中心推荐任务列表
    [DownLoadData postGetRecommendMission:^(id obj, NSError *error) {
        self.dataArr = obj[@"SUCCESS"];
        
        //刷新tableView
        [self.tableView reloadData];
    } userId:[HCJFNSUser stringForKey:@"userId"]];
    //积分商城推荐商品
    [DownLoadData postVipRegister:^(id obj, NSError *error) {
        self.shopArr = obj[@"SUCCESS"];
        //刷新tableView
        [self.tableView reloadData];
    } isDelete:@"0" isRecommend:@"1" pageNum:@"1" pageSize:@"4"];
}
#pragma mark ===tableViewDataSource delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section) {
        return 2;
    }else{
        return self.dataArr.count+2;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //会员中心头部
            static NSString *reuse = @"VipHeaderCell";
            VipHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
            if (!cell) {
                cell = [[VipHeaderCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuse];
            }
            cell.model = _vipClubModel;
            
            return cell;
        }else{
            if (indexPath.row == 1) {
                static NSString *reuse = @"UITableViewCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuse];
                }
                cell.selectionStyle = NO;
                cell.textLabel.text = @"赚积分";
                cell.textLabel.font = [UIFont systemFontOfSize:30*m6Scale];
                cell.textLabel.textColor = UIColorFromRGB(0x343434);
                cell.detailTextLabel.text = @"更多攻略";
                cell.detailTextLabel.font = [UIFont systemFontOfSize:28*m6Scale];
                cell.detailTextLabel.textColor = UIColorFromRGB(0x8B8A8A);
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                return cell;
            }else{
                MoreStrategyModel *model = self.dataArr[indexPath.row-2];
                if (self.dataArr.count) {
                    
                    static NSString *reuse = @"UITableViewCell";
                    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
                    if (!cell) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuse];
                    }
                    cell.selectionStyle = NO;
                    
                    UIImageView *logoImage = [UIImageView new];
                    logoImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", model.icon]]]];
                    [cell.contentView addSubview:logoImage];
                    [logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.mas_equalTo(cell.contentView.mas_centerY);
                        make.left.mas_equalTo(30*m6Scale);
                        make.size.mas_equalTo(CGSizeMake(80*m6Scale, 80*m6Scale));
                    }];
                    UILabel *titleLab = [Factory CreateLabelWithTextColor:0.5 andTextFont:28 andText:[NSString stringWithFormat:@"%@", model.remark] addSubView:cell.contentView];
                    titleLab.textColor = UIColorFromRGB(0x373737);
                    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(logoImage.mas_right).offset(40*m6Scale);
                        make.centerY.mas_equalTo(logoImage);
                    }];
                    //赚积分标签
                    UIButton *label = [UIButton buttonWithType:0];
                    label.tag = 1000+indexPath.row-2;
                    [cell addSubview:label];
                    [label mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.right.mas_equalTo(-20*m6Scale);
                        make.centerY.mas_equalTo(cell.contentView.mas_centerY);
                        make.size.mas_equalTo(CGSizeMake(123*m6Scale, 60*m6Scale));
                    }];
                    [label addTarget:self action:@selector(skipToVCByIntegralType:) forControlEvents:UIControlEventTouchUpInside];
                    label.titleLabel.font = [UIFont systemFontOfSize:26*m6Scale];
                    label.layer.cornerRadius = 30*m6Scale;
                    label.layer.masksToBounds = YES;
                    label.titleLabel.textColor = [UIColor whiteColor];
                    [label setTitle:@"赚积分" forState:0];
                    label.backgroundColor = UIColorFromRGB(0xFF6935);
                    
                    return cell;
                }else{
                    return nil;
                }
            }
        }
    }else{
        if (indexPath.row == 0) {
            static NSString *reuse = @"bottom";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuse];
            }
            cell.textLabel.text = @"花积分";
            cell.detailTextLabel.text = @"积分商城";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.font = [UIFont systemFontOfSize:30*m6Scale];
            cell.textLabel.textColor = UIColorFromRGB(0x343434);
            cell.detailTextLabel.font = [UIFont systemFontOfSize:28*m6Scale];
            cell.detailTextLabel.textColor = UIColorFromRGB(0x8B8A8A);
            cell.selectionStyle = NO;
            
            return cell;
        }else{
            static NSString *reuse = @"bottom";
            VipBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
            if (!cell) {
                cell = [[VipBottomCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuse];
            }
            cell.selectionStyle = NO;
            if (self.shopArr.count) {
                NSLog(@"%@", self.shopArr);
                [cell cellForArray:self.shopArr];
            }
            
            return cell;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section) {
        if (indexPath.row) {
            if (kStatusBarHeight > 20) {
                return 550*m6Scale+50;
            }else{
                return 550*m6Scale;
            }
        }else{
            return 80*m6Scale;
        }
    }else{
        if (indexPath.row) {
            if (indexPath.row == 1) {
                return 80*m6Scale;
            }else{
                return 100*m6Scale;
            }
        }else{
            if (kStatusBarHeight > 20) {
                return 495*m6Scale+50;
            }else{
                return 495*m6Scale;
            }
        }
    }
}
/**
 *点击单元格时间
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section) {
        if (indexPath.row == 0) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            //兑吧免登陆接口
            [DownLoadData postLogFreeUrl:^(id obj, NSError *error) {
                [hud hideAnimated:YES];
                IntegralShopVC *tempVC = [IntegralShopVC new];
                tempVC.strUrl = obj[@"ret"];
                [self.navigationController pushViewController:tempVC animated:YES];
            } userId:[HCJFNSUser stringForKey:@"userId"] redicrect:@""];
        }
    }else{
        if (indexPath.row == 1) {
            //跳转至更多攻略界面
            MoreStrategyVC *tempVC = [MoreStrategyVC new];
            //用户当前积分
            tempVC.intergral = [NSString stringWithFormat:@"%@", _vipClubModel.usable];
            [self.navigationController pushViewController:tempVC animated:YES];
        }else if (indexPath.row == 0){
            
        }
    }
}
/**
 *根据integralType跳转相应的页面  1实名；2邀请好友，3首次开启自动投标；4设置锁投；5-投资；6-积分商城消费；7-签到；8-活动福利
 */
- (void)skipToVCByIntegralType:(UIButton *)sender{
    MoreStrategyModel *model = self.dataArr[sender.tag - 1000];
    NSString *integralType = [NSString stringWithFormat:@"%@", model.integralType];
    switch (integralType.integerValue) {
        case 1:{
            //实名
            ScanIdentityVC *tempVC = [ScanIdentityVC new];
            [self.navigationController pushViewController:tempVC animated:YES];
        }
            break;
        case 2:{
            //邀请好友
            NewInviteFriendVC *tempVC = [NewInviteFriendVC new];
            [self.navigationController pushViewController:tempVC animated:YES];
        }
            break;
        case 3:{
            //首次开启自动投标
            AutoBidSettingViewController *tempVC = [AutoBidSettingViewController new];
            [self.navigationController pushViewController:tempVC animated:YES];
        }
            
            break;
        case 4:{
            //设置锁投
            IphoneVC *tempVC = [IphoneVC new];
            [self.navigationController pushViewController:tempVC animated:YES];
        }
            break;
        case 5:{
            //投资
            NSNotification *notification = [[NSNotification alloc] initWithName:@"GoToInvest" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
            break;
        case 6:{//积分商城消费
            //积分商城
            ClipActivityController *strVC = [ClipActivityController new];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:strVC.navigationController.view animated:YES];
            //兑吧免登陆接口
            [DownLoadData postLogFreeUrl:^(id obj, NSError *error) {
                [hud hideAnimated:YES];
                IntegralShopVC *tempVC = [IntegralShopVC new];
                tempVC.strUrl = obj[@"ret"];
                [strVC.navigationController pushViewController:tempVC animated:YES];
            } userId:[HCJFNSUser stringForKey:@"userId"] redicrect:@""];
        }
            break;
        case 7:{//签到
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            break;
        case 8:{
            //活动福利
            MywelfareVC *tempVC = [MywelfareVC new];
            [self.navigationController pushViewController:tempVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 网易七鱼返回
- (void)onBack:(UINavigationItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark Navigation上面的两个按钮
/**
 右边按钮，帮助中心,客服电话
 */
- (void)helpCenter{
    ActivityCenterVC *tempVC = [ActivityCenterVC new];
    tempVC.tag = 50;
    tempVC.strUrl = @"/html/vipLevel.html";
    tempVC.urlName = @"会员规则";
    [self.navigationController pushViewController:tempVC animated:YES]; 
}
/**
 *权益按钮点击事件
 */
- (void)buttonClick:(NSNotification *)noti{
    NSString *tag = noti.userInfo[@"sender"];
    switch (tag.integerValue) {
        case 100:
            //每日惊喜
            [Factory alertMes:@"敬请期待"];
            break;
        case 101:
            //生日享礼
            [self vipPushViewByName:@"生日享礼"];
            break;
        case 102:
            //升级礼包
            [self vipPushViewByName:@"升级礼包"];
            break;
        case 103:
            //更多权益(跳转至会员权益)
            [self TapClick];
            break;
            
        default:
            break;
    }
    
}
/**
 *获取权益弹屏
 */
- (void)vipPushViewByName:(NSString *)name{
    //获取权益弹屏
    [DownLoadData postGetMemberPicture:^(id obj, NSError *error) {
        NSString *picName = obj[@"ret"][@"picturePath"];
        
        [self makeSurePictureFrameByPicName:name andPicUrl:[NSURL URLWithString:picName]];
    } picName:name];
}
/**
 *确定图片大小
 */
- (void)makeSurePictureFrameByPicName:(NSString *)picName andPicUrl:(NSURL *)url{
    self.pushView.hidden = NO;
    NSLog(@"%@", url);
    if ([picName isEqualToString:@"生日享礼"]) {
        self.pushView.pushImgView.frame = CGRectMake((kScreenWidth-570*m6Scale)/2, (kScreenHeight-690*m6Scale)/2, 570*m6Scale, 690*m6Scale);
        [self.pushView.investBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(150*m6Scale);
        }];
    }else if([picName isEqualToString:@"升级礼包"]){
        self.pushView.pushImgView.frame = CGRectMake((kScreenWidth-570*m6Scale)/2, (kScreenHeight-834*m6Scale)/2, 570*m6Scale, 834*m6Scale);
        [self.pushView.investBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(150*m6Scale);
        }];
    }
    [self.pushView.pushImgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"750x500"]];
}
/**
 *弹屏
 */
- (PushImgView *)pushView{
    if(!_pushView){
        _pushView = [[PushImgView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _pushImg = [[UIImageView alloc] init];
        
        [self.view addSubview:_pushView];
        [_pushView addSubview:_pushImg];
    }
    return _pushView;
}
/**
 *跳转至会员权益
 */
- (void)TapClick{
    VipEquityVC *tempVC = [VipEquityVC new];
    tempVC.money = self.userMoney;//用户的财气值
    tempVC.userName = self.userName;//用户名称
    tempVC.vipGrade = self.vipGrade;//会员等级
    
    [self.navigationController pushViewController:tempVC animated:YES];
}
/**
 *  左边按钮返回
 */
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.pushView.hidden = YES;
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    UIImage *colorImage = [Factory imageWithColor:[UIColor clearColor] size:CGSizeMake(self.view.frame.size.width, 0.5)];
    [self.navigationController.navigationBar setBackgroundImage:colorImage forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setShadowImage:[Factory imageWithColor:[UIColor colorWithWhite:0.5 alpha:1] size:CGSizeMake(self.view.frame.size.width, 0.5)]];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    //导航设置
    self.navigationController.navigationBar.translucent = YES;
    UIImage *colorImage = [Factory imageWithColor:[UIColor clearColor] size:CGSizeMake(self.view.frame.size.width, 0.001)];
    [self.navigationController.navigationBar setBackgroundImage:colorImage forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setShadowImage:[Factory imageWithColor:[UIColor clearColor] size:CGSizeMake(self.view.frame.size.width, 0.001)]];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [Factory hidentabar];
    [Factory navgation:self];
}

@end
